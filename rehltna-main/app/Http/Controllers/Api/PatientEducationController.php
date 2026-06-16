<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\DiseaseType;
use App\Models\PatientEducation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PatientEducationController extends Controller
{
    use ResponseTrait;

    public function getPatientsEducations(Request $request): JsonResponse
    {
        $query = PatientEducation::query()->where('status', 1)->with('diseaseType');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $patients = $query->orderByDesc('id')->paginate(10);
        $total = $patients->total();
        $data = [
            'patients_count' => $total,
            'patients' => $patients,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getPatient($slug): JsonResponse
    {
        $patient = PatientEducation::query()->with('diseaseType')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->firstOrFail();
        if (!$patient)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $patient);
    }

    public function getPatientsByDiseaseType($id): JsonResponse
    {
        $diseaseType = DiseaseType::query()->find($id);
        if (!$diseaseType)
            return $this->responseMessage(404, 'not found');

        $patients_educations = $diseaseType->patientsEducation()->orderByDesc('id')->paginate(10);
        $data = [
            'disease_type' => $diseaseType,
            'patients_educations_count' => $patients_educations->total(),
            'patients_educations' => $patients_educations,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getPatientsEducationsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $patientsEducationsFeatures = PatientEducation::query()->with('diseaseType')->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $patientsEducationsFeatures);
    }

}
