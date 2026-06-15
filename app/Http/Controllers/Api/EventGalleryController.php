<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\EventGallery;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EventGalleryController extends Controller
{
    use ResponseTrait;

    public function getEventsGalleries(Request $request): JsonResponse
    {
        $query = EventGallery::query()->where('status', 1)->with('galleries');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $EventsGalleries = $query->orderByDesc('id')->paginate(10);
        $total = $EventsGalleries->total();
        $data = [
            'events_galleries_count' => $total,
            'events_galleries' => $EventsGalleries,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getEventGallery($id): JsonResponse
    {
        $EventGallery = EventGallery::query()->with('galleries')->find($id);
        if (!$EventGallery)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $EventGallery);
    }

    public function getEventsGalleriesFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $eventsGalleriesFeatures = EventGallery::query()->orderByDesc('id')->where('status', 1)->where('is_feature', 1)->with('galleries')->take($number)->get();
        return $this->responseMessage(200, 'success', $eventsGalleriesFeatures);
    }

}
