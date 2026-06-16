<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\PortfolioCategory;
use Illuminate\Http\JsonResponse;

class PortfolioCategoryController extends Controller
{
    use ResponseTrait;

    public function getCategories(): JsonResponse
    {
        $categories = PortfolioCategory::query()->orderByDesc('id')->withCount('portfolios')
            ->with('portfolios')
            ->paginate(10);
        return $this->responseMessage(200, 'success', $categories);
    }

}
