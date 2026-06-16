<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\ApplyJob;
use App\Models\Career;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ApplyJobController extends Controller
{
    use ResponseTrait;

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'career_id' => [
                'required',
                Rule::exists(Career::class, 'id'),
            ],
            'name' => 'required|string',
            'phone' => 'required|string',
            'email' => 'required|email',
            'cv' => 'required|file|max:5000|mimes:pdf',
        ]);

        try {

            if (ApplyJob::query()->where('email', $request->get('email'))->where('status', 'pending')->where('career_id', $request->get('career_id'))->exists())
                return $this->responseMessage(400, 'You have already applied pending for this career');

            $path = uploadFile($request->file('cv'), 'cvs', 'cv');

            ApplyJob::query()->create([
                'career_id' => $request->get('career_id'),
                'name' => $request->get('name'),
                'phone' => $request->get('phone'),
                'email' => $request->get('email'),
                'cv' => $path,
            ]);

            return $this->responseMessage(201, 'Application submitted successfully.');

        } catch (\Exception $e) {
            return $this->responseMessage(400, 'Oops! something went wrong.');
        }
    }
}
