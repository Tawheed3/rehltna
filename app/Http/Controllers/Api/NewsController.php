<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\News;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    use ResponseTrait;

    public function getNews(Request $request): JsonResponse
    {
        $query = News::query()->where('status', 1);
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        if ($request->get('type')) {
            $query = $query->where('type', $request->get('type'));
        }

        $news = $query->orderByDesc('id')->paginate(10);
        $total = $news->total();
        $data = [
            'news_count' => $total,
            'news' => $news,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getNew($id): JsonResponse
    {
        $new = News::query()->find($id);
        if (!$new)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $new);
    }

    public function getNewsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;

        $query = News::query()->orderByDesc('id')->where('status', 1)->where('is_feature', 1);

        if ($request->get('type')) {
            $query = $query->where('type', $request->get('type'));
        }

        $newsFeatures = $query->take($number)->get();

        return $this->responseMessage(200, 'success', $newsFeatures);
    }
}
