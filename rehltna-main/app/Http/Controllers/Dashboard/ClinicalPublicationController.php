<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\ClinicalPublication;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ClinicalPublicationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $clinicalPublications = ClinicalPublication::query()->orderByDesc('id')->paginate(10);
        return view('pages.clinical-publications.index', compact('clinicalPublications'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        return view('pages.clinical-publications.create');
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

            $ClinicalPublication = ClinicalPublication::query()->create($data);
            $ClinicalPublication->setAttribute('order', $request->get('order'));
            $ClinicalPublication->save();

            return redirect()->route('clinical-publications.index')->with('success', 'Clinical Publication created successfully.');

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
        $clinicalPublication = ClinicalPublication::query()->findOrFail(decrypt($id));
        return view('pages.clinical-publications.edit', compact('clinicalPublication'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $clinicalPublication = ClinicalPublication::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                if ($clinicalPublication->banner_ar && file_exists(public_path($clinicalPublication->banner_ar))) {
                    unlink(public_path($clinicalPublication->banner_ar));
                }
                $file = $request->file('banner_ar');
                $name = time() . '_ar.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_ar'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('banner_en')) {
                if ($clinicalPublication->banner_en && file_exists(public_path($clinicalPublication->banner_en))) {
                    unlink(public_path($clinicalPublication->banner_en));
                }
                $file = $request->file('banner_en');
                $name = time() . '_en.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_en'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('meta_img')) {
                if ($clinicalPublication->meta_img && file_exists(public_path($clinicalPublication->meta_img))) {
                    unlink(public_path($clinicalPublication->meta_img));
                }
                $file = $request->file('meta_img');
                $name = time() . '_meta.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/meta'), $name);
                $data['meta_img'] = 'uploads/meta/' . $name;
            }

            $clinicalPublication->fill($data);
            $clinicalPublication->setAttribute('order', $request->get('order'));
            $clinicalPublication->save();

            return redirect()->route('clinical-publications.index')->with('success', 'Clinical publication updated successfully.');

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

            $clinicalPublication = ClinicalPublication::query()->findOrFail($id);

            if ($clinicalPublication->banner_ar && file_exists(public_path($clinicalPublication->banner_ar))) {
                unlink(public_path($clinicalPublication->banner_ar));
            }

            if ($clinicalPublication->banner_en && file_exists(public_path($clinicalPublication->banner_en))) {
                unlink(public_path($clinicalPublication->banner_en));
            }

            if ($clinicalPublication->meta_img && file_exists(public_path($clinicalPublication->meta_img))) {
                unlink(public_path($clinicalPublication->meta_img));
            }

            $clinicalPublication->delete();

            return redirect()->route('clinical-publications.index')->with('success', 'Clinical publication deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function clinicalPublicationsChangeStatus($id): JsonResponse
    {
        $clinicalPublication = ClinicalPublication::query()->findOrFail($id);
        if ($clinicalPublication->status == 1) {
            $clinicalPublication->status = 0;
            $clinicalPublication->save();
        } else {
            $clinicalPublication->status = 1;
            $clinicalPublication->save();
        }
        return response()->json(['status' => $clinicalPublication->status]);
    }

    public function clinicalPublicationsChangeIsFeature($id): JsonResponse
    {
        $clinicalPublication = ClinicalPublication::query()->findOrFail($id);
        if ($clinicalPublication->is_feature == 1) {
            $clinicalPublication->is_feature = 0;
            $clinicalPublication->save();
        } else {
            $clinicalPublication->is_feature = 1;
            $clinicalPublication->save();
        }
        return response()->json(['is_feature' => $clinicalPublication->is_feature]);
    }
}
