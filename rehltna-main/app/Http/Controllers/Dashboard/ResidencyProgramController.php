<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\DiseaseType;
use App\Models\ResidencyProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ResidencyProgramController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $residencies = ResidencyProgram::query()->orderByDesc('id')->paginate(10);
        return view('pages.residencies.index', compact('residencies'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        $diseaseTypes = DiseaseType::all();
        return view('pages.residencies.create', compact('diseaseTypes'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                $bannerAr = $request->file('banner_ar');
                $bannerArName = time() . '_ar.' . $bannerAr->getClientOriginalExtension();
                $bannerAr->move(public_path('uploads/banners'), $bannerArName);
                $data['banner_ar'] = 'uploads/banners/' . $bannerArName;
            }
            if ($request->hasFile('banner_en')) {
                $bannerEn = $request->file('banner_en');
                $bannerEnName = time() . '_en.' . $bannerEn->getClientOriginalExtension();
                $bannerEn->move(public_path('uploads/banners'), $bannerEnName);
                $data['banner_en'] = 'uploads/banners/' . $bannerEnName;
            }
            if ($request->hasFile('meta_img')) {
                $metaImg = $request->file('meta_img');
                $metaImgName = time() . '_meta.' . $metaImg->getClientOriginalExtension();
                $metaImg->move(public_path('uploads/meta'), $metaImgName);
                $data['meta_img'] = 'uploads/meta/' . $metaImgName;
            }

            $ResidencyProgram = ResidencyProgram::query()->create($data);
            $ResidencyProgram->setAttribute('order', $request->get('order'));
            $ResidencyProgram->save();

            return redirect()->route('residencies.index')->with('success', 'Residency created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }


    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): view
    {
        $residency = ResidencyProgram::query()->findOrFail(decrypt($id));
        $diseaseTypes = DiseaseType::all();
        return view('pages.residencies.edit', compact('residency', 'diseaseTypes'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $residency = ResidencyProgram::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                if ($residency->banner_ar && file_exists(public_path($residency->banner_ar))) {
                    unlink(public_path($residency->banner_ar));
                }
                $file = $request->file('banner_ar');
                $name = time() . '_ar.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_ar'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('banner_en')) {
                if ($residency->banner_en && file_exists(public_path($residency->banner_en))) {
                    unlink(public_path($residency->banner_en));
                }
                $file = $request->file('banner_en');
                $name = time() . '_en.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_en'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('meta_img')) {
                if ($residency->meta_img && file_exists(public_path($residency->meta_img))) {
                    unlink(public_path($residency->meta_img));
                }
                $file = $request->file('meta_img');
                $name = time() . '_meta.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/meta'), $name);
                $data['meta_img'] = 'uploads/meta/' . $name;
            }

            $residency->fill($data);
            $residency->setAttribute('order', $request->get('order'));
            $residency->save();

            return redirect()->route('residencies.index')->with('success', 'Residency updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {

            $residency = ResidencyProgram::query()->findOrFail($id);

            if ($residency->banner_ar && file_exists(public_path($residency->banner_ar))) {
                unlink(public_path($residency->banner_ar));
            }

            if ($residency->banner_en && file_exists(public_path($residency->banner_en))) {
                unlink(public_path($residency->banner_en));
            }

            if ($residency->meta_img && file_exists(public_path($residency->meta_img))) {
                unlink(public_path($residency->meta_img));
            }

            $residency->delete();

            return redirect()->route('residencies.index')->with('success', 'Residency deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function residenciesChangeStatus($id): JsonResponse
    {
        $residency = ResidencyProgram::query()->findOrFail($id);
        if ($residency->status == 1) {
            $residency->status = 0;
            $residency->save();
        } else {
            $residency->status = 1;
            $residency->save();
        }
        return response()->json(['status' => $residency->status]);
    }

    public function residenciesChangeIsFeature($id): JsonResponse
    {
        $residency = ResidencyProgram::query()->findOrFail($id);
        if ($residency->is_feature == 1) {
            $residency->is_feature = 0;
            $residency->save();
        } else {
            $residency->is_feature = 1;
            $residency->save();
        }
        return response()->json(['is_feature' => $residency->is_feature]);
    }
}
