<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\LeadMagnet;
use App\Models\LeadMagnetType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class LeadMagnetController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $leadMagnets = LeadMagnet::query()->with('type')->withCount('leads')->orderByDesc('id')->paginate(10);
        $types = LeadMagnetType::all();
        return view('pages.leadMagnets.index', compact('leadMagnets', 'types'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        $types = LeadMagnetType::all();
        return view('pages.leadMagnets.create', compact('types'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $activeLangs = get_active_langs();

            $exclude = [];
            $exclude[] = 'files';
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            LeadMagnet::query()->create($data);

            return redirect()->route('lead-magnets.index')->with('success', 'Lead Magnet created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $leadmagnet = LeadMagnet::query()->findOrFail(decrypt($id));
        $types = LeadMagnetType::all();
        return view('pages.leadMagnets.edit', compact('leadmagnet', 'types'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $leadMagnet = LeadMagnet::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            $exclude = [];
            $exclude[] = 'files';
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            $leadMagnet->update($data);

            return redirect()->route('lead-magnets.index')->with('success', 'Lead Magnet updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {

            $leadMagnet = LeadMagnet::query()->findOrFail($id);

            $leadMagnet->delete();

            return redirect()->route('lead-magnets.index')->with('success', 'Lead Magnet deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Change status (Active/Inactive)
     */
    public function changeStatus($id): JsonResponse
    {
        $leadMagnet = LeadMagnet::query()->findOrFail($id);
        $leadMagnet->status = !$leadMagnet->status;
        $leadMagnet->save();
        return response()->json(['status' => $leadMagnet->status]);
    }

    /**
     * Helper to clean domain from URL
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }
}
