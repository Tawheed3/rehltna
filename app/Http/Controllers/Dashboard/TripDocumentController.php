<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\ResidencyUser;
use App\Models\TripDocument;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use Illuminate\Support\Facades\Storage;

class TripDocumentController extends Controller
{
    public function index(): View
    {
        $documents = TripDocument::with(['item', 'users'])
            ->orderByDesc('id')
            ->paginate(15);

        return view('pages.trip-documents.index', compact('documents'));
    }

    public function create(): View
    {
        $trips = Item::orderBy('start_date')->get(['id', 'title_ar', 'season', 'start_date']);
        $users = ResidencyUser::orderBy('name')->get(['id', 'name', 'email']);

        return view('pages.trip-documents.create', compact('trips', 'users'));
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'item_id'        => 'required|exists:items,id',
            'pdf'            => 'nullable|file|mimes:pdf|max:20480',
            'details'        => 'nullable|array',
            'details.*.key'      => 'required_with:details|string|max:255',
            'details.*.value'    => 'required_with:details|string',
            'details.*.location' => 'nullable|url|max:2048',
            'users'              => 'nullable|array',
            'users.*'            => 'exists:residency_users,id',
        ]);

        // One document per trip — delete old one if exists
        $old = TripDocument::where('item_id', $request->item_id)->first();
        if ($old) {
            if ($old->pdf_path) Storage::disk('public')->delete($old->pdf_path);
            $old->delete();
        }

        $pdfPath = null;
        if ($request->hasFile('pdf')) {
            $pdfPath = $request->file('pdf')->store('trip-documents', 'public');
        }

        $details = collect($request->details ?? [])
            ->filter(fn($row) => !empty($row['key']) && !empty($row['value']))
            ->map(fn($row) => [
                'key'      => $row['key'],
                'value'    => $row['value'],
                'location' => !empty($row['location']) ? $row['location'] : null,
            ])
            ->values()
            ->toArray();

        $document = TripDocument::create([
            'item_id'  => $request->item_id,
            'pdf_path' => $pdfPath,
            'details'  => $details,
        ]);

        $document->users()->sync($request->users ?? []);

        return redirect()->route('trip-documents.index')
            ->with('success', 'تم إنشاء وثيقة الرحلة بنجاح.');
    }

    public function edit(TripDocument $tripDocument): View
    {
        $trips = Item::orderBy('start_date')->get(['id', 'title_ar', 'season', 'start_date']);
        $users = ResidencyUser::orderBy('name')->get(['id', 'name', 'email']);
        $tripDocument->load(['item', 'users']);

        return view('pages.trip-documents.edit', compact('tripDocument', 'trips', 'users'));
    }

    public function update(Request $request, TripDocument $tripDocument): RedirectResponse
    {
        $request->validate([
            'item_id'        => 'required|exists:items,id',
            'pdf'            => 'nullable|file|mimes:pdf|max:20480',
            'details'        => 'nullable|array',
            'details.*.key'      => 'required_with:details|string|max:255',
            'details.*.value'    => 'required_with:details|string',
            'details.*.location' => 'nullable|url|max:2048',
            'users'              => 'nullable|array',
            'users.*'            => 'exists:residency_users,id',
        ]);

        $pdfPath = $tripDocument->pdf_path;

        if ($request->hasFile('pdf')) {
            if ($pdfPath) Storage::disk('public')->delete($pdfPath);
            $pdfPath = $request->file('pdf')->store('trip-documents', 'public');
        }

        if ($request->boolean('remove_pdf') && $pdfPath) {
            Storage::disk('public')->delete($pdfPath);
            $pdfPath = null;
        }

        $details = collect($request->details ?? [])
            ->filter(fn($row) => !empty($row['key']) && !empty($row['value']))
            ->map(fn($row) => [
                'key'      => $row['key'],
                'value'    => $row['value'],
                'location' => !empty($row['location']) ? $row['location'] : null,
            ])
            ->values()
            ->toArray();

        $tripDocument->update([
            'item_id'  => $request->item_id,
            'pdf_path' => $pdfPath,
            'details'  => $details,
        ]);

        $tripDocument->users()->sync($request->users ?? []);

        return redirect()->route('trip-documents.index')
            ->with('success', 'تم تحديث وثيقة الرحلة بنجاح.');
    }

    public function destroy(TripDocument $tripDocument): RedirectResponse
    {
        if ($tripDocument->pdf_path) {
            Storage::disk('public')->delete($tripDocument->pdf_path);
        }
        $tripDocument->delete();

        return redirect()->route('trip-documents.index')
            ->with('success', 'تم حذف الوثيقة بنجاح.');
    }
}
