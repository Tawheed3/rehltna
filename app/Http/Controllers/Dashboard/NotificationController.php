<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\ResidencyUser;
use App\Jobs\SendPushNotificationJob;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class NotificationController extends Controller
{
    public function index(): View
    {
        $users = ResidencyUser::whereNotNull('fcm_token')->select('id', 'name', 'phone')->get();
        $packages = Package::select('id', 'name_en', 'name_ar')->get();

        return view('pages.notifications.index', compact('users', 'packages'));
    }

    public function send(Request $request): RedirectResponse
    {
        $request->validate([
            'title'        => 'required|string|max:255',
            'body'         => 'required|string',
            'target_type'  => 'required|in:all,users,packages',
            'user_ids'     => 'required_if:target_type,users|array',
            'package_ids'  => 'required_if:target_type,packages|array',
            'scheduled_at' => 'nullable|date|after:now',
        ]);

        $tokens = [];

        if ($request->target_type == 'all') {
            $tokens = ResidencyUser::whereNotNull('fcm_token')->pluck('fcm_token')->toArray();
        } elseif ($request->target_type == 'users') {
            $tokens = ResidencyUser::whereIn('id', $request->user_ids)
                ->whereNotNull('fcm_token')->pluck('fcm_token')->toArray();
        } elseif ($request->target_type == 'packages') {
            $tokens = ResidencyUser::whereIn('package_id', $request->package_ids)
                ->whereNotNull('fcm_token')->pluck('fcm_token')->toArray();
        }

        if (empty($tokens)) {
            return redirect()->back()->with('warning', 'No users with valid tokens found in the selected target group.');
        }

        $count = count($tokens);

        $scheduledAt = null;
        if ($request->filled('scheduled_at')) {
            $scheduledAt = \Carbon\Carbon::createFromFormat('Y-m-d\TH:i', $request->scheduled_at, 'Asia/Riyadh');
        }

        foreach ($tokens as $token) {
            $job = new SendPushNotificationJob(
                $token,
                $request->title,
                $request->body,
                ['type' => 'general_announcement']
            );
            dispatch($scheduledAt ? $job->delay($scheduledAt) : $job);
        }

        if ($scheduledAt) {
            $formatted = $scheduledAt->format('d M Y \a\t h:i A') . ' (Saudi Time)';
            return redirect()->back()->with('success', "Notifications scheduled for {$formatted} — will be sent to {$count} user(s).");
        }

        return redirect()->back()->with('success', "Notifications are successfully queued for {$count} user(s).");
    }
}
