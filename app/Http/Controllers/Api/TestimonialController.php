<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Testimonial;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TestimonialController extends Controller
{
    use ResponseTrait;

    public function index(): JsonResponse
    {
        $testimonials = Testimonial::query()->where('status', 1)->orderByDesc('id')->paginate(10);
        return $this->responseMessage(200, 'success', $testimonials);
    }

    public function store(Request $request): JsonResponse
    {
        if (!empty($request->extra_key)) {
            return $this->responseMessage(403, 'Spam detected.');
        }

        $data = $request->validate([
            'name' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg,webp|max:2048',
            'email' => 'required|email',
            'testimonial' => 'required|string|max:255',
        ]);

        try {

            if ($request->hasFile('image')) {
                $data['image'] = uploadFile($request->file('image'), 'testimonials', 'testimonial');
            }

            Testimonial::query()->create($data);

            return $this->responseMessage(201, 'Testimonial submitted successfully.');

        } catch (\Exception $e) {
            return $this->responseMessage(400, 'Oops! something went wrong.');
        }
    }

}
