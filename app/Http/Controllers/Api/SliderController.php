<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Slider;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class SliderController extends Controller
{
    use ResponseTrait;

    public function getSliders(): JsonResponse
    {
        $sliders = Cache::remember('api_sliders', 300, function () {
            return Slider::query()->where('status', 1)->orderBy('order', 'asc')->get();
        });

        return $this->responseMessage(200, 'success', $sliders, 300);
    }
}
