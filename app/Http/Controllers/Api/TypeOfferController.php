<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\TypeOffer;
use Illuminate\Http\JsonResponse;

class TypeOfferController extends Controller
{
    use ResponseTrait;

    public function getOfferTypes(): JsonResponse
    {
        $typeOffers = TypeOffer::query()->orderByDesc('id')->withCount('offers')
            ->with(['offers' => function ($query) {
                $query->orderByDesc('id')->take(3);
            }])
            ->paginate(10);

        return $this->responseMessage(200, 'success', $typeOffers);
    }

}
