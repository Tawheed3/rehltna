<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\View\View;

class SettingController extends Controller
{
    public function index(): View
    {
        return view('pages.social-integration.index');
    }

    public function getSettings(): View
    {
        return view('pages.settings.index');
    }

    /**
     * Update or Create Settings
     * Handles: Gallery URLs (Logos), Manual File Uploads (PDFs), JSON Arrays (Socials/Address), and Strings.
     */
    public function updateOrCreateSettings(Request $request): RedirectResponse
    {
        $jsonKeys = [
            'facebook', 'instagram', 'twitter', 'whatsapp', 'linkedin', 'youtube',
            'tiktok', 'snapchat', 'active_langs',
        ];

        foreach (get_active_langs() as $lang) {
            $jsonKeys[] = 'site_address_' . $lang;
        }

        $galleryKeys = ['main_logo_light', 'main_logo_dark', 'favicon'];

        foreach ($request->except(['_token', '_method']) as $key => $value) {

            if ($request->hasFile($key)) {
                $oldSetting = Setting::query()->where('key', $key)->first();
                if ($oldSetting && $oldSetting->value) {
                    deleteFiles([$oldSetting->value]);
                }

                $file = $request->file($key);
                $value = uploadFile($file, 'settings', 'settings');
            }

            elseif (in_array($key, $galleryKeys) && !empty($value)) {
                $value = $this->cleanPath($value);
            }

            if (in_array($key, $jsonKeys) || is_array($value)) {
                if (is_array($value)) {
                    $value = array_values(array_filter($value, function($item) {
                        return !is_null($item) && $item !== '';
                    }));
                }
                $value = json_encode($value);
            }

            if (is_null($value)) {
                continue;
            }

            Setting::query()->updateOrCreate(
                ['key' => $key],
                ['value' => $value]
            );
        }

        Cache::forget('api_settings_' . getTenantId());
        return back()->with('success', 'Settings updated successfully.');
    }

    /**
     * Helper to clean URL domain from the path for Gallery Picker storage
     */
    private function cleanPath($path): array|string
    {
        return str_replace(url('/'), '', $path);
    }

    public function updateOrCreate(Request $request): RedirectResponse
    {
        $keys = $request->input('keys', []);
        $values = $request->input('values', []);
        $statuses = $request->input('status', []);

        foreach ($keys as $index => $key) {
            $value = $values[$index] ?? '';
            $status = isset($statuses[$key]) ? 1 : 0;

            Setting::query()->updateOrCreate(['key' => $key], ['value' => $value]);
            Setting::query()->updateOrCreate(['key' => str_replace('_id', '', $key)], ['value' => $status]);
        }

        Cache::forget('api_settings_' . getTenantId());
        return redirect()->back()->with('success', 'Settings updated successfully.');
    }
}
