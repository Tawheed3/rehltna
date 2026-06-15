<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Event;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EventController extends Controller
{
    use ResponseTrait;

    public function getEvents(Request $request): JsonResponse
    {
        $query = Event::query()->where('status', 1)->with('galleries');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $Events = $query->orderByDesc('id')->paginate(10);
        $total = $Events->total();
        $data = [
            'events_count' => $total,
            'events' => $Events,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getEvent($id): JsonResponse
    {
        $Event = Event::query()->with('galleries')->find($id);
        if (!$Event)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $Event);
    }

    public function getEventsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $eventsFeatures = Event::query()->orderByDesc('id')->where('status', 1)->where('is_feature', 1)->with('galleries')->take($number)->get();
        return $this->responseMessage(200, 'success', $eventsFeatures);
    }
}
