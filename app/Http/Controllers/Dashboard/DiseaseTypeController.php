<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\DiseaseType;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class DiseaseTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $diseaseTypes = DiseaseType::query()->orderByDesc('id')->paginate(10);
        return view('pages.disease-types.index', compact('diseaseTypes'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            DiseaseType::query()->create([
                'name_en' => $request->get('name_en'),
                'name_ar' => $request->get('name_ar'),
            ]);
            return redirect()->route('disease-types.index')->with('success', 'Disease Type created successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(DiseaseType $diseaseType)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(DiseaseType $diseaseType)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): \Illuminate\Http\RedirectResponse
    {
        try {
            $DiseaseType = DiseaseType::query()->findOrFail($id);
            $DiseaseType->update([
                'name_en' => $request->get('name_en'),
                'name_ar' => $request->get('name_ar'),
            ]);
            return redirect()->route('disease-types.index')->with('success', 'Disease Type updated successfully');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        $DiseaseType = DiseaseType::query()->findOrFail($id);
        $DiseaseType->delete();
        return redirect()->route('disease-types.index')->with('success', 'Disease Type deleted successfully');
    }
}
