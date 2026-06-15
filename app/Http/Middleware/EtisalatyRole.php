<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EtisalatyRole
{
    public function handle(Request $request, Closure $next, string $role = 'security')
    {
        $user = $request->etisalaty_user;

        if (!$user || $user->etisalaty_role !== $role) {
            return response()->json([
                'code'    => 403,
                'message' => 'Access denied. This action requires the "' . $role . '" role.',
                'data'    => null,
            ], 403);
        }

        return $next($request);
    }
}
