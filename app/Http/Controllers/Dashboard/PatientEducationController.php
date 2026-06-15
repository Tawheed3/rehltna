<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\DiseaseType;
use App\Models\PatientEducation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PatientEducationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $patients = PatientEducation::query()->orderByDesc('id')->paginate(10);
        return view('pages.patients.index', compact('patients'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        $diseaseTypes = DiseaseType::all();
        return view('pages.patients.create', compact('diseaseTypes'));
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

            $PatientEducation = PatientEducation::query()->create($data);
            $PatientEducation->setAttribute('order', $request->get('order'));
            $PatientEducation->save();

            return redirect()->route('patients.index')->with('success', 'Patient created successfully.');

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
        $patient = PatientEducation::query()->findOrFail(decrypt($id));
        $diseaseTypes = DiseaseType::all();
        return view('pages.patients.edit', compact('patient', 'diseaseTypes'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $patient = PatientEducation::query()->findOrFail($id);

            $data = $request->except(['banner_ar', 'banner_en', 'meta_img']);

            if ($request->hasFile('banner_ar')) {
                if ($patient->banner_ar && file_exists(public_path($patient->banner_ar))) {
                    unlink(public_path($patient->banner_ar));
                }
                $file = $request->file('banner_ar');
                $name = time() . '_ar.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_ar'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('banner_en')) {
                if ($patient->banner_en && file_exists(public_path($patient->banner_en))) {
                    unlink(public_path($patient->banner_en));
                }
                $file = $request->file('banner_en');
                $name = time() . '_en.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/banners'), $name);
                $data['banner_en'] = 'uploads/banners/' . $name;
            }

            if ($request->hasFile('meta_img')) {
                if ($patient->meta_img && file_exists(public_path($patient->meta_img))) {
                    unlink(public_path($patient->meta_img));
                }
                $file = $request->file('meta_img');
                $name = time() . '_meta.' . $file->getClientOriginalExtension();
                $file->move(public_path('uploads/meta'), $name);
                $data['meta_img'] = 'uploads/meta/' . $name;
            }

            $patient->fill($data);
            $patient->setAttribute('order', $request->get('order'));
            $patient->save();

            return redirect()->route('patients.index')->with('success', 'Patient updated successfully.');

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

            $patient = PatientEducation::query()->findOrFail($id);

            if ($patient->banner_ar && file_exists(public_path($patient->banner_ar))) {
                unlink(public_path($patient->banner_ar));
            }

            if ($patient->banner_en && file_exists(public_path($patient->banner_en))) {
                unlink(public_path($patient->banner_en));
            }

            if ($patient->meta_img && file_exists(public_path($patient->meta_img))) {
                unlink(public_path($patient->meta_img));
            }

            $patient->delete();

            return redirect()->route('patients.index')->with('success', 'Patient deleted successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', $e->getMessage());
        }
    }

    public function patientsChangeStatus($id): JsonResponse
    {
        $patient = PatientEducation::query()->findOrFail($id);
        if ($patient->status == 1) {
            $patient->status = 0;
            $patient->save();
        } else {
            $patient->status = 1;
            $patient->save();
        }
        return response()->json(['status' => $patient->status]);
    }

    public function patientsChangeIsFeature($id): JsonResponse
    {
        $patient = PatientEducation::query()->findOrFail($id);
        if ($patient->is_feature == 1) {
            $patient->is_feature = 0;
            $patient->save();
        } else {
            $patient->is_feature = 1;
            $patient->save();
        }
        return response()->json(['is_feature' => $patient->is_feature]);
    }
}
