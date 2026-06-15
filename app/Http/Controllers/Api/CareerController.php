<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Career;
use App\Models\CareerType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CareerController extends Controller
{
    use ResponseTrait;

    public function getCareers(Request $request): JsonResponse
    {
        $query = Career::query()->where('status', 1)->with('careerType');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $careers = $query->orderByDesc('id')->paginate(10);
        $total = $careers->total();
        $data = [
            'careers_count' => $total,
            'careers' => $careers,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getCareer($slug): JsonResponse
    {
        $career = Career::query()->with('careerType')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->first();
        if (!$career)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $career);
    }

    public function getCareersByCareerType($id): JsonResponse
    {
        $careerType = CareerType::query()->find($id);
        if (!$careerType)
            return $this->responseMessage(404, 'not found');

        $careers = $careerType->careers()->with('careerType')->orderByDesc('id')->paginate(10);
        $data = [
            'careerType' => $careerType,
            'careers_count' => $careers->total(),
            'careers' => $careers,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

}
