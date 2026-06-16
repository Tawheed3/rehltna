<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Protocol;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProtocolController extends Controller
{
    use ResponseTrait;

    public function getProtocols(Request $request): JsonResponse
    {
        $query = Protocol::query()->where('status', 1);
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $protocols = $query->orderByDesc('id')->paginate(10);
        $total = $protocols->total();
        $data = [
            'protocols_count' => $total,
            'protocols' => $protocols,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getProtocol($slug): JsonResponse
    {
        $protocol = Protocol::query()->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->firstOrFail();
        if (!$protocol)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $protocol);
    }

    public function getProtocolsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $protocolsFeatures = Protocol::query()->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $protocolsFeatures);
    }

}
