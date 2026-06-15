<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\CareerType;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CareerTypeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $careerTypes = CareerType::query()->withCount('careers')->paginate(10);
        return view('pages.career-types.index', compact('careerTypes'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.career-types.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                $data['banner_ar'] = uploadFile($request->file('banner_ar'), 'banners', 'ar');
            }
            if ($request->hasFile('banner_en')) {
                $data['banner_en'] = uploadFile($request->file('banner_en'), 'banners', 'en');
            }
            if ($request->hasFile('meta_img')) {
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            CareerType::query()->create($data);

            return redirect()->route('career-types.index')->with('success', 'Type created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with(['error' => 'Oops! Something went wrong']);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(CareerType $careerType)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $careerType = CareerType::query()->findOrFail(decrypt($id));
        return view('pages.career-types.edit', compact('careerType'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $careerType = CareerType::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                deleteFiles([$careerType->banner_ar]);
                $data['banner_ar'] = uploadFile($request->file('banner_ar'), 'banners', 'ar');
            }

            if ($request->hasFile('banner_en')) {
                deleteFiles([$careerType->banner_en]);
                $data['banner_en'] = uploadFile($request->file('banner_en'), 'banners', 'en');
            }

            if ($request->hasFile('meta_img')) {
                deleteFiles([$careerType->meta_img]);
                $data['meta_img'] = uploadFile($request->file('meta_img'), 'meta', 'meta');
            }

            $careerType->update($data);

            return redirect()->route('career-types.index')->with('success', 'Type updated successfully.');

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

            $careerType = CareerType::query()->findOrFail($id);
            deleteFiles([$careerType->meta_img, $careerType->banner_en, $careerType->banner_ar]);
            $careerType->delete();

            return redirect()->route('career-types.index')->with('success', 'Type deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }
}
