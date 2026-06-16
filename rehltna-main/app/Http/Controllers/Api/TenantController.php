<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Tenant;
use Illuminate\Http\JsonResponse;

class TenantController extends Controller
{
    use ResponseTrait;

    public function index(): JsonResponse
    {
        $tenants = Tenant::query()->select('id', 'name')->get();
        return $this->responseMessage(200, 'success', $tenants);
    }
}
