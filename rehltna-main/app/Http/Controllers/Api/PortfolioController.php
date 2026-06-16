<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Portfolio;
use App\Models\PortfolioCategory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PortfolioController extends Controller
{
    use ResponseTrait;

    public function getPortfolios(Request $request): JsonResponse
    {
        $query = Portfolio::query()->where('status', 1)->with('category', 'galleries');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('name_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('name_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $portfolios = $query->orderByDesc('id')->paginate(10);
        $total = $portfolios->total();
        $data = [
            'portfolios_count' => $total,
            'portfolios' => $portfolios,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getPortfolio($slug): JsonResponse
    {
        $portfolio = Portfolio::query()->with('category', 'galleries')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->firstOrFail();
        if (!$portfolio)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $portfolio);
    }

    public function getPortfoliosByCategory($id): JsonResponse
    {
        $category = PortfolioCategory::query()->find($id);
        if (!$category)
            return $this->responseMessage(404, 'not found');

        $portfolios = $category->portfolios()->with('category', 'galleries')->orderByDesc('id')->paginate(10);
        $data = [
            'category' => $category,
            'portfolios_count' => $portfolios->total(),
            'portfolios' => $portfolios,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

}
