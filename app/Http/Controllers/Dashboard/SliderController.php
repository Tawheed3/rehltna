<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Slider;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class SliderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): view
    {
        $sliders = Slider::query()->orderBy('order', 'asc')->get();
        return view('pages.sliders.index', compact('sliders'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): view|RedirectResponse
    {
        $sliders = Slider::query()->count();
        if ($sliders >= 5)
            return redirect()->route('sliders.index')->with('warning', 'Maximum 5 Sliders allowed');

        return view('pages.sliders.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {
            $sliders = Slider::query()->count();
            if ($sliders >= 5)
                return redirect()->route('sliders.index')->with('warning', 'Maximum 5 Sliders allowed');

            $activeLangs = get_active_langs();

            $exclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            Slider::query()->create($data);

            return redirect()->route('sliders.index')->with('success', 'Slider created successfully');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $slider = Slider::query()->findOrFail(decrypt($id));
        return view('pages.sliders.edit', compact('slider'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $slider = Slider::query()->findOrFail($id);
            $activeLangs = get_active_langs();

            $exclude = ['meta_img'];
            foreach ($activeLangs as $lang) {
                $exclude[] = 'banner_' . $lang;
            }

            $data = $request->except($exclude);

            foreach ($activeLangs as $lang) {
                if ($request->filled('banner_' . $lang)) {
                    $data['banner_' . $lang] = $this->cleanPath($request->input('banner_' . $lang));
                }
            }

            if ($request->filled('meta_img')) {
                $data['meta_img'] = $this->cleanPath($request->input('meta_img'));
            }

            $slider->update($data);

            return redirect()->route('sliders.index')->with('success', 'Slider updated successfully.');

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

            $slider = Slider::query()->findOrFail($id);

            $slider->delete();

            return redirect()->route('sliders.index')->with('success', 'Slider deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Helper to clean domain from URL
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function SlidersChangeStatus($id): JsonResponse
    {
        $slider = Slider::query()->findOrFail($id);
        $slider->status = $slider->status == 1 ? 0 : 1;
        $slider->save();
        return response()->json(['status' => $slider->status]);
    }
}
