<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Lead;
use App\Models\LeadMagnet;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class LeadController extends Controller
{
    use ResponseTrait;

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */

    public function store(Request $request): JsonResponse
    {
        if (!empty($request->extra_key)) {
            return $this->responseMessage(403, 'Spam detected.');
        }

        $request->validate([
            'email' => 'required|email|unique:leads,email',
            'lead_magnet_id' => [
                'required',
                Rule::exists(LeadMagnet::class, 'id'),
            ],
        ]);

        try {

            Lead::query()->create($request->only('email', 'lead_magnet_id'));
            return $this->responseMessage(201, 'Lead submitted successfully.');

        } catch (\Exception $e) {


            // Check for unique constraint violation (SQLSTATE code 23000 or 1062 for MySQL)
            if ($e->getCode() === '23000') {
                return $this->responseMessage(409, 'This email is already Leaded.');
            }

            return $this->responseMessage(400, 'Oops! Something went wrong.');


        }
    }


    /**
     * Display the specified resource.
     */
    public function show(Lead $lead)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Lead $lead)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Lead $lead)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Lead $lead)
    {
        //
    }
}
