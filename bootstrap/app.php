<?php

use App\Http\Middleware\IdentifyTenant;
use Illuminate\Auth\Middleware\Authenticate;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;


return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
        then: function ($router) {
            require __DIR__ . '/../routes/admin.php';
        }
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->redirectUsersTo(function () {
            return '/admin/dashboard';
        });
        $middleware->redirectGuestsTo('/admin');
        $middleware->priority([
            IdentifyTenant::class,
            Authenticate::class,
        ]);
        $middleware->alias([
            'permission' => \App\Http\Middleware\CheckPermission::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->render(function (ValidationException $e, $request) {
            if ($request->expectsJson()) {
                return response()->json([
                    'code' => 422,
                    'message' => 'Validation errors',
                    'data' => $e->errors(),
                ], 422);
            }
        });
        $exceptions->render(function (AuthenticationException $e, $request) {
            if ($request->expectsJson()) {
                return response()->json([
                    'code' => 401,
                    'message' => 'Unauthorized : Token not found or invalid',
                    'data' => null
                ], 401);
            }
        });

        $exceptions->render(function (NotFoundHttpException $e, $request) {
            if ($request->expectsJson()) {
                return response()->json([
                    'code' => 404,
                    'message' => 'Resource not found.',
                    'data' => null
                ], 404);
            }
        });

        $exceptions->render(function (MethodNotAllowedHttpException $e, $request) {
            if ($request->expectsJson()) {
                return response()->json([
                    'code' => 405,
                    'message' => 'Method not allowed.',
                    'data' => null
                ], 405);
            }
        });
    })->create();
