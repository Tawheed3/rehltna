<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\ClinicalPublication;
use App\Models\Protocol;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ClinicalPublicationController extends Controller
{
    use ResponseTrait;

    public function getClinicalPublications(Request $request): JsonResponse
    {
        $query = ClinicalPublication::query()->where('status', 1);
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $clinicalPublications = $query->orderByDesc('id')->paginate(10);
        $total = $clinicalPublications->total();
        $data = [
            'clinical_publications_count' => $total,
            'clinical_publications' => $clinicalPublications,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getClinicalPublication($slug): JsonResponse
    {
        $clinicalPublication = ClinicalPublication::query()->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->firstOrFail();
        if (!$clinicalPublication)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $clinicalPublication);
    }

    public function getClinicalPublicationsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $clinicalPublicationsFeatures = ClinicalPublication::query()->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $clinicalPublicationsFeatures);
    }

}
