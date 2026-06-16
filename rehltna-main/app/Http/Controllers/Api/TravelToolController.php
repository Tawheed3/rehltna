<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\TravelTool;
use Illuminate\Http\JsonResponse;

class TravelToolController extends Controller
{
    use ResponseTrait;

    public function getTravelTools(): JsonResponse
    {
        $tools = TravelTool::query()
            ->where('is_active', true)
            ->orderBy('order')
            ->orderBy('id')
            ->get(['id', 'title', 'description', 'icon', 'order']);

        return $this->responseMessage(200, 'success', $tools);
    }
}
