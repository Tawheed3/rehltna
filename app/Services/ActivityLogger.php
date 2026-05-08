<?php

namespace App\Services;

use App\Models\ActivityLog;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Request;

class ActivityLogger
{
    public static function log(string $action, string $description, ?string $subjectType = null, ?int $subjectId = null): void
    {
        $user = Auth::user();

        ActivityLog::create([
            'user_id'      => $user?->id,
            'user_name'    => $user?->name ?? 'System',
            'action'       => $action,
            'subject_type' => $subjectType,
            'subject_id'   => $subjectId,
            'description'  => $description,
            'ip_address'   => Request::ip(),
            'created_at'   => now(),
        ]);
    }
}
