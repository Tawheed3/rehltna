<?php

use App\Models\Setting;
use App\Models\Tenant;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Collection;

if (!function_exists('get_setting')) {
    function get_setting($key)
    {
        // Static cache: load all settings once per request per tenant to avoid N+1 queries.
        // PHP-FPM resets statics between requests, so there is no cross-request leakage.
        static $cache = [];
        $tenantId = (string) (getTenantId() ?: 0);
        if (!array_key_exists($tenantId, $cache)) {
            $cache[$tenantId] = Setting::all()->pluck('value', 'key')->all();
        }
        return $cache[$tenantId][$key] ?? null;
    }
}

if (!function_exists('get_active_langs')) {
    function get_active_langs(): array
    {
        $defaults = ['ar', 'en', 'fr', 'de'];

        $dbSettings = get_setting('active_langs');

        if (is_string($dbSettings)) {
            $decoded = json_decode($dbSettings, true);
            if (is_array($decoded) && count($decoded) > 0) {
                return $decoded;
            }
        }

        if (is_array($dbSettings) && count($dbSettings) > 0) {
            return $dbSettings;
        }

        return $defaults;
    }
}

if (!function_exists('get_lang_enabled')) {
    function get_lang_enabled(string $lang): bool
    {
        return in_array($lang, get_active_langs());
    }
}

if (!function_exists('hasArabic')) {
    function hasArabic(): bool
    {
        return get_lang_enabled('ar');
    }
}

if (!function_exists('hasEnglish')) {
    function hasEnglish(): bool
    {
        return get_lang_enabled('en');
    }
}

if (!function_exists('hasFrench')) {
    function hasFrench(): bool
    {
        return get_lang_enabled('fr');
    }
}

if (!function_exists('hasGerman')) {
    function hasGerman(): bool
    {
        return get_lang_enabled('de');
    }
}

if (!function_exists('colClass')) {

    function colClass(): string
    {
        $count = count(get_active_langs());

        return match ($count) {
            1 => 'col-md-12',
            2 => 'col-md-6',
            3 => 'col-md-4',
            4 => 'col-md-3',
            default => 'col-md-12',
        };
    }
}

if (!function_exists('getTenantInfo')) {
    function getTenantInfo(): Tenant|Collection|Model|null
    {
        return Tenant::query()->find(getTenantId());
    }
}

if (!function_exists('checkIfAdmin')) {
    function checkIfAdmin(): bool
    {
        $user = auth()->user();
        return $user && $user->role === 'admin';
    }
}

if (!function_exists('downloadAndSaveImage')) {

    function downloadAndSaveImage(?string $url, string $type, $prefix = null): ?string
    {
        if (empty($url) || !filter_var($url, FILTER_VALIDATE_URL)) {
            return null;
        }

        // Block non-HTTP(S) schemes (file://, ftp://, etc.)
        $scheme = strtolower(parse_url($url, PHP_URL_SCHEME) ?? '');
        if (!in_array($scheme, ['http', 'https'], true)) {
            return null;
        }

        // Block loopback / private IP ranges (SSRF prevention)
        $host = strtolower(parse_url($url, PHP_URL_HOST) ?? '');
        if (in_array($host, ['localhost', '0.0.0.0', '::1'], true)) {
            return null;
        }
        $resolvedIp = gethostbyname($host);
        if (filter_var($resolvedIp, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) === false) {
            return null;
        }

        try {
            $ctx = stream_context_create(['http' => ['timeout' => 10], 'https' => ['timeout' => 10]]);
            $imageContent = file_get_contents($url, false, $ctx);
            if ($imageContent === false || strlen($imageContent) < 12) {
                return null;
            }

            // Validate actual content is an image via MIME (not URL extension)
            $mimeExtMap = [
                'image/jpeg' => 'jpg',
                'image/png'  => 'png',
                'image/gif'  => 'gif',
                'image/webp' => 'webp',
            ];
            $mimeType = (new \finfo(FILEINFO_MIME_TYPE))->buffer($imageContent);
            if (!isset($mimeExtMap[$mimeType])) {
                return null;
            }

            $extension = $mimeExtMap[$mimeType];
            $fileName  = uniqid() . '_' . time() . ($prefix ? "_{$prefix}" : '') . '.' . $extension;
            $path      = public_path("uploads/tenant_" . getTenantId() . "/{$type}/");
            if (!file_exists($path)) {
                mkdir($path, 0777, true);
            }
            file_put_contents($path . $fileName, $imageContent);
            return "uploads/tenant_" . getTenantId() . "/{$type}/" . $fileName;
        } catch (\Exception $e) {
            return null;
        }
    }

}

if (!function_exists('uploadFile')) {
    function uploadFile(UploadedFile $file, string $folder, string $prefix = null): string
    {
        // getMimeType() uses PHP finfo on the actual file bytes, not the client-supplied filename.
        $mimeExtMap = [
            'image/jpeg'      => 'jpg',
            'image/png'       => 'png',
            'image/gif'       => 'gif',
            'image/webp'      => 'webp',
            'image/svg+xml'   => 'svg',
            'application/pdf' => 'pdf',
            'video/mp4'       => 'mp4',
            'video/quicktime' => 'mov',
            'video/x-msvideo' => 'avi',
            'video/webm'      => 'webm',
        ];

        $mimeType  = $file->getMimeType();
        $extension = $mimeExtMap[$mimeType] ?? null;

        if ($extension === null) {
            throw new \InvalidArgumentException("File type not allowed: {$mimeType}");
        }

        $path     = "uploads/tenant_" . getTenantId() . "/{$folder}";
        $fileName = uniqid() . '_' . time() . ($prefix ? "_{$prefix}" : '') . '.' . $extension;
        if (!file_exists(public_path($path))) {
            mkdir(public_path($path), 0777, true);
        }
        $file->move(public_path($path), $fileName);
        return "{$path}/{$fileName}";
    }
}

if (!function_exists('deleteFiles')) {
    function deleteFiles(array $files): void
    {
        foreach ($files as $file) {
            if ($file) {
                $relativePath = str_replace(url('/') . '/', '', $file);
                $normalizedPath = ltrim($relativePath, '/');
                $fullPath = public_path($normalizedPath);
                if (file_exists($fullPath)) {
                    @unlink($fullPath);
                }
            }
        }
    }
}


if (!function_exists('getTenantId')) {
    function getTenantId(): bool|int
    {
        if (session()->has('tenant_id')) {
            return session('tenant_id');
        }

        $request = request();
        if ($request->hasHeader('X-Tenant-ID')) {
            return $request->header('X-Tenant-ID');
        }

        if ($request->has('tenant_id')) {
            return $request->get('tenant_id');
        }

        return false;
    }
}

if (!function_exists('safeParseDate')) {
    function safeParseDate($value): Carbon
    {
        if ($value instanceof Carbon) {
            return $value;
        }

        $value = str_replace(' - ', ' ', $value);
        if (preg_match('/\b(1[3-9]|2[0-3]):\d{2}\s?(AM|PM)\b/i', $value)) {
            $value = preg_replace('/\s?(AM|PM)\b/i', '', $value);
        }

        return Carbon::parse($value);
    }
}

if (!function_exists('transDB')) {
    function transDB($model, $field)
    {
        if (!$model) return '';
        $currentLang = session('lang', app()->getLocale());
        if (!empty($model->{$field . '_' . $currentLang})) {
            return $model->{$field . '_' . $currentLang};
        }

        $fallbacks = ['en', 'ar', 'fr', 'de'];

        foreach ($fallbacks as $lang) {
            if ($lang === $currentLang) continue;
            $value = $model->{$field . '_' . $lang} ?? null;
            if (!empty($value)) {
                return $value;
            }
        }

        return '';
    }
}
