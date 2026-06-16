<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\DiseaseType;
use App\Models\ResidencyProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ResidencyProgramController extends Controller
{
    use ResponseTrait;

    public function getResidenciesPrograms(Request $request): JsonResponse
    {
        $query = ResidencyProgram::query()->where('status', 1)->with('diseaseType');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $residencies = $query->orderByDesc('id')->paginate(10);
        $total = $residencies->total();
        $data = [
            'residencies_count' => $total,
            'residencies' => $residencies,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getResidency($slug): JsonResponse
    {
        $residency = ResidencyProgram::query()->with('diseaseType')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->firstOrFail();
        if (!$residency)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $residency);
    }

    public function getResidenciesByDiseaseType($id): JsonResponse
    {
        $diseaseType = DiseaseType::query()->find($id);
        if (!$diseaseType)
            return $this->responseMessage(404, 'not found');

        $residencies_programs = $diseaseType->residenciesProgram()->orderByDesc('id')->paginate(10);
        $data = [
            'disease_type' => $diseaseType,
            'residencies_programs_count' => $residencies_programs->total(),
            'residencies_programs' => $residencies_programs,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getResidenciesProgramFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $residenciesProgramFeatures = ResidencyProgram::query()->with('diseaseType')->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $residenciesProgramFeatures);
    }

}
