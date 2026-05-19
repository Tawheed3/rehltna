<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\ItemType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class ItemTypeController extends Controller
{
    use ResponseTrait;

    public function getItemTypes(): JsonResponse
    {
        $today = now()->toDateString();
        $itemTypes = ItemType::query()
            ->whereNull('parent_id')
            ->orderByDesc('id')
            ->withCount(['items' => fn($q) => $q->where('status', 1)->where('start_date', '>=', $today)])
            ->with([
                'children' => function ($q) use ($today) {
                    $q->withCount(['items' => fn($q2) => $q2->where('status', 1)->where('start_date', '>=', $today)]);
                },
                'items.galleries' => function ($query) {
                    $query->orderByDesc('id')->take(3);
                }
            ])->paginate(10);

        return $this->responseMessage(200, 'success', $itemTypes);
    }

    public function getItemTypesWithAllItems(): JsonResponse
    {
        $itemTypes = ItemType::query()->orderByDesc('id')->withCount('items')
            ->with(['items.galleries' => function ($query) {
                $query->orderByDesc('id');
            }])
            ->paginate(10);

        return $this->responseMessage(200, 'success', $itemTypes);
    }

    public function getItemTypesFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $itemTypesFeatures = ItemType::query()->orderByDesc('id')->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $itemTypesFeatures);
    }
}
