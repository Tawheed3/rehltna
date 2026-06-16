<?php

namespace App\Http\Middleware;

use App\Http\Traits\ResponseTrait;
use App\Models\Tenant;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class IdentifyTenant
{
    use ResponseTrait;

    /**
     * Handle an incoming request.
     *
     * @param \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response) $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $tenantId = $request->header('X-Tenant-ID') ?? $request->get('tenant_id');

        if ($tenantId) {
            $tenant = Tenant::query()->find($tenantId);
            if ($tenant) {
                $tenant->makeCurrent();
            } else {
                return $this->responseMessage(404, 'Tenant not found.');
            }
        } else {
            return $this->responseMessage(400, 'Tenant ID not provided.');
        }
        return $next($request);
    }
}
