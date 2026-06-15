<?php

namespace App\Jobs;

use App\Models\ContactUs;
use App\Models\RegisterUsers;
use App\Models\Tenant;
use Illuminate\Bus\Queueable;
use Illuminate\Support\Facades\Mail;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

class SendRegisterUserReplyJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected int $register_user_id;
    protected string $reply;
    protected int $tenant_id;

    public function __construct(int $register_user_id, string $reply, int $tenant_id)
    {
        $this->register_user_id = $register_user_id;
        $this->reply = $reply;
        $this->tenant_id = $tenant_id;
    }

    public function handle(): void
    {
        $tenant = Tenant::query()->findOrFail($this->tenant_id);
        $tenant->makeCurrent();

        $registerUser = RegisterUsers::query()->findOrFail($this->register_user_id);

        Mail::send(
            'emails.register-user-reply',
            ['registerUser' => $registerUser, 'reply' => $this->reply],
            function ($message) use ($registerUser) {
                $message->to($registerUser->email)
                    ->subject('Reply to Your Message');
            }
        );
    }
}
