<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\LeadMagnetType;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class LeadMagnetTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $types = LeadMagnetType::query()->orderByDesc('id')->paginate(10);
        return view('pages.lead_magnet_types.index', compact('types'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.lead_magnet_types.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        $activeLangs = get_active_langs();
        $rules = [];
        $data = [];

        foreach ($activeLangs as $lang) {
            $rules['name_' . $lang] = 'required|string|max:255';
            $data['name_' . $lang] = $request->get('name_' . $lang);
        }

        $request->validate($rules);

        try {

            LeadMagnetType::query()->create($data);

            return redirect()->route('lead-magnet-types.index')->with('success', 'Lead magnet type created successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(LeadMagnetType $leadMagnetType): View
    {
        return view('pages.lead_magnet_types.edit', compact('leadMagnetType'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        $activeLangs = get_active_langs();
        $rules = [];
        $data = [];

        foreach ($activeLangs as $lang) {
            $rules['name_' . $lang] = 'required|string|max:255';
            $data['name_' . $lang] = $request->get('name_' . $lang);
        }

        $request->validate($rules);

        try {
            $type = LeadMagnetType::query()->findOrFail($id);

            $type->update($data);

            return redirect()->route('lead-magnet-types.index')->with('success', 'Lead magnet type updated successfully');
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
            $type = LeadMagnetType::query()->findOrFail($id);
            $type->delete();

            return redirect()->route('lead-magnet-types.index')->with('success', 'Lead magnet type deleted successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }
}
