<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckPermission
{
    public function handle(Request $request, Closure $next, string $permission): mixed
    {
        $user = Auth::user();

        if (!$user) {
            return redirect()->route('admin.login.form');
        }

        // Admins bypass all permission checks
        if ($user->role === 'admin') {
            return $next($request);
        }

        if (!$user->hasPermission($permission)) {
            return redirect()->route('dashboard')
                ->with('error', 'You do not have permission to access this section.');
        }

        return $next($request);
    }
}
