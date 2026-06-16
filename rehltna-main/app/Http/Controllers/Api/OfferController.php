<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Offer;
use App\Models\TypeOffer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OfferController extends Controller
{
    use ResponseTrait;

    public function getOffers(Request $request): JsonResponse
    {
        $query = Offer::query()->where('status', 1)->with('offerType');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $offers = $query->orderByDesc('id')->paginate(10);
        $total = $offers->total();
        $data = [
            'offers_count' => $total,
            'offers' => $offers,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getOffer($slug): JsonResponse
    {
        $offer = Offer::query()->with('offerType')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->first();
        if (!$offer)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $offer);
    }

    public function getOffersByOfferType($id): JsonResponse
    {
        $offerType = TypeOffer::query()->find($id);
        if (!$offerType)
            return $this->responseMessage(404, 'not found');

        $offers = $offerType->offers()->with('offerType')->orderByDesc('id')->paginate(10);
        $data = [
            'offerType' => $offerType,
            'offers_count' => $offers->total(),
            'offers' => $offers,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getOffersFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $offerFeatures = Offer::query()->with('offerType')->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $offerFeatures);
    }
}
