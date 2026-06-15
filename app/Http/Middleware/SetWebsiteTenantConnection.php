<?php

namespace App\Http\Middleware;

use App\Models\Tenant;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class SetWebsiteTenantConnection
{
    /**
     * Handle an incoming request.
     *
     * @param \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response) $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (
            $request->is('api/*') ||
            $request->is('admin/*')
        ) {
            return $next($request);
        }

        $tenant = Tenant::query()->first();

        if ($tenant) {
            config([
                'database.connections.tenant.database' => $tenant->db_name,
                'database.connections.tenant.username' => $tenant->db_username,
                'database.connections.tenant.password' => $tenant->db_password,
                'database.connections.tenant.host' => $tenant->db_host,
            ]);

            DB::purge('tenant');

            $tenant->makeCurrent();

            DB::reconnect('tenant');
        }

        return $next($request);
    }

}
