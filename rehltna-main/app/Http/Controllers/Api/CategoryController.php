<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Category;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    use ResponseTrait;

    public function getCategories(): JsonResponse
    {
        $categories = Category::query()
            ->orderByDesc('id')
            ->withCount(['blogs as blogs_count' => function ($query) {
                $query->where('status', 1);
            }])
            ->with(['blogs' => function ($query) {
                $query->where('status', 1)
                    ->orderByDesc('id')
                    ->take(3);
            }])
            ->paginate(10);

        return $this->responseMessage(200, 'success', $categories);
    }


}
