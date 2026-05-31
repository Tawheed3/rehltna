<?php

namespace App\Http\Traits;

use Illuminate\Http\JsonResponse;

trait ResponseTrait
{
    public function responseMessage($code, $message = null, $data = null, int $cacheSeconds = 0): JsonResponse
    {
        $response = response()->json([
            'code' => $code,
            'message' => $message,
            'data' => $data
        ], $code >= 400 ? $code : 200);

        if ($cacheSeconds > 0 && $code === 200) {
            $response->header('Cache-Control', "public, max-age={$cacheSeconds}, s-maxage={$cacheSeconds}");
        } else {
            $response->header('Cache-Control', 'no-store, no-cache, must-revalidate');
        }

        return $response;
    }
}
