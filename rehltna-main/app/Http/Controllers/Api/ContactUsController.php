<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\ContactUs;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ContactUsController extends Controller
{
    use ResponseTrait;

    public function store(Request $request): JsonResponse
    {
        if (!empty($request->extra_key)) {
            return $this->responseMessage(403, 'Spam detected.');
        }

        $request->validate([
            'name' => 'required|string',
            'phone' => 'required|string',
            'email' => 'required|email',
            'message' => 'required|string|max:200',
        ]);

        try {

            ContactUs::query()->create($request->only('name', 'phone', 'email', 'message'));
            return $this->responseMessage(201, 'Contact submitted successfully.');

        } catch (\Exception $e) {
            return $this->responseMessage(400, 'Oops! something went wrong.');
        }
    }
}
