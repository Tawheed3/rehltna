<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Subscribe;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class SubscribeController extends Controller
{
    use ResponseTrait;

    public function store(Request $request): JsonResponse
    {
        if (!empty($request->extra_key)) {
            return $this->responseMessage(403, 'Spam detected.');
        }

        $request->validate([
            'email' => [
                'required',
                Rule::unique(Subscribe::class, 'email'),
            ],
        ]);

        try {

            Subscribe::query()->create($request->only('email'));
            return $this->responseMessage(201, 'Subscribe submitted successfully.');

        } catch (\Exception $e) {


            // Check for unique constraint violation (SQLSTATE code 23000 or 1062 for MySQL)
            if ($e->getCode() === '23000') {
                return $this->responseMessage(409, 'This email is already subscribed.');
            }

            return $this->responseMessage(400, 'Oops! Something went wrong.');


        }
    }

}
