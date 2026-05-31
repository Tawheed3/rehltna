<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class SettingController extends Controller
{
    use ResponseTrait;

    public function index(): JsonResponse
    {
        $fileKeys = [
            'main_logo_dark',
            'main_logo_light',
            'favicon',
            'company_profile_en',
            'company_profile_ar'
        ];

        $settings = Cache::remember('api_settings', 300, function () use ($fileKeys) {
            return Setting::all()->mapWithKeys(function ($setting) use ($fileKeys) {
                $value = $setting->value;

                if (in_array($setting->key, $fileKeys) && $value) {
                    $filePath = public_path($value);
                    $value = file_exists($filePath) ? asset($value) : null;
                }

                return [$setting->key => $value];
            });
        });

        return $this->responseMessage(200, 'Settings', $settings, 300);
    }
}
