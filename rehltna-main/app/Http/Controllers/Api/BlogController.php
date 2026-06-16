<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Blog;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BlogController extends Controller
{
    use ResponseTrait;

    public function getBlogs(Request $request): JsonResponse
    {
        $query = Blog::query()->where('status', 1)->with('category');
        if ($request->get('search')) {
            $query = $query->where(function ($query) use ($request) {
                $query->where('title_en', 'like', '%' . $request->get('search') . '%')
                    ->orWhere('title_ar', 'like', '%' . $request->get('search') . '%');
            });
        }

        $blogs = $query->orderByDesc('id')->paginate(10);
        $total = $blogs->total();
        $data = [
            'blogs_count' => $total,
            'blogs' => $blogs,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getBlog($slug): JsonResponse
    {
        $blog = Blog::query()->with('category')->where(function ($query) use ($slug) {
            $query->where('slug_en', $slug)->orWhere('slug_ar', $slug);
        })->first();
        if (!$blog)
            return $this->responseMessage(404, 'not found');

        return $this->responseMessage(200, 'success', $blog);
    }

    public function getBlogsByCategory($id): JsonResponse
    {
        $category = Category::query()->find($id);
        if (!$category)
            return $this->responseMessage(404, 'not found');

        $blogs = $category->blogs()->where('status', 1)->with('category')->orderByDesc('id')->paginate(10);
        $data = [
            'category' => $category,
            'blogs_count' => $blogs->total(),
            'blogs' => $blogs,
        ];

        return $this->responseMessage(200, 'success', $data);
    }

    public function getBlogsFeatures(Request $request): JsonResponse
    {
        $number = $request->get('number') ?? 3;
        $blogsFeatures = Blog::query()->with('category')->where('status', 1)->where('is_feature', 1)->take($number)->get();
        return $this->responseMessage(200, 'success', $blogsFeatures);
    }

}
