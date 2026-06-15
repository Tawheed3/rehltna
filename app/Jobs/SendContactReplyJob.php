<?php

namespace App\Jobs;

use App\Models\ContactUs;
use Illuminate\Bus\Queueable;
use Illuminate\Support\Facades\Mail;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

class SendContactReplyJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected ContactUs $contact;
    protected string $reply;

    public function __construct(ContactUs $contact, string $reply)
    {
        $this->contact = $contact;
        $this->reply = $reply;
    }
    public function handle(): void
    {
        Mail::send('emails.contact-reply', ['contact' => $this->contact, 'reply' => $this->reply], function ($message) {
            $message->to($this->contact->email)
                ->subject('Reply to Your Message');
        });
    }
}
