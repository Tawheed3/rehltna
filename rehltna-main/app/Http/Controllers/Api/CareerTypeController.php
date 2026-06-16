<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\CareerType;
use Illuminate\Http\JsonResponse;

class CareerTypeController extends Controller
{
    use ResponseTrait;

    public function getCareerTypes(): JsonResponse
    {
        $careerTypes = CareerType::query()->orderByDesc('id')->withCount('careers')
            ->with(['careers' => function ($query) {
                $query->orderByDesc('id')->take(3);
            }])
            ->paginate(10);

        return $this->responseMessage(200, 'success', $careerTypes);
    }
}
