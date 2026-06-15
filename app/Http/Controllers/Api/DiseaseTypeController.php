<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\DiseaseType;
use Illuminate\Http\JsonResponse;

class DiseaseTypeController extends Controller
{
    use ResponseTrait;

    public function getDiseaseTypes(): JsonResponse
    {
        $diseaseTypes = DiseaseType::query()->orderByDesc('id')->withCount('patientsEducation', 'residenciesProgram')
            ->with(['patientsEducation' => function ($query) {
                $query->orderByDesc('id')->take(3);
            }, 'residenciesProgram' => function ($query) {
                $query->orderByDesc('id')->take(3);
            }])
            ->paginate(10);

        return $this->responseMessage(200, 'success', $diseaseTypes);
    }

}
