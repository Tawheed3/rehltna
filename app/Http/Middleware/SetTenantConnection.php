<?php

namespace App\Http\Middleware;

use App\Models\Tenant;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SetTenantConnection
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (session()->has('tenant_id')) {

            $tenant = Tenant::query()->find(session('tenant_id'));
            if ($tenant) {
                $tenant->makeCurrent();
            }

        } else {
            return redirect()->route('tenants.index');
        }

        return $next($request);
    }
}
