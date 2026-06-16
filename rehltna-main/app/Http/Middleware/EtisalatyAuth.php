<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;

class EtisalatyAuth
{
    public function handle(Request $request, Closure $next)
    {
        $bearerToken = $request->bearerToken();

        if (!$bearerToken) {
            return response()->json(['code' => 401, 'message' => 'Token not provided.', 'data' => null], 401);
        }

        $token = PersonalAccessToken::findToken($bearerToken);

        if (!$token || !($token->tokenable instanceof User) || !$token->tokenable->etisalaty_role) {
            return response()->json(['code' => 401, 'message' => 'Invalid or expired token.', 'data' => null], 401);
        }

        $request->merge(['etisalaty_user' => $token->tokenable]);

        return $next($request);
    }
}
