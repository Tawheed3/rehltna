<?php

namespace App\Mail;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class OrderNeedsReviewMail extends Mailable
{
    use Queueable, SerializesModels;

    public Order $order;

    public function __construct(Order $order)
    {
        $this->order = $order->loadMissing('items.item');
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: '🔔 New Receipt Uploaded — Order #' . $this->order->id . ' Needs Review',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.orders.needs_review',
        );
    }
}
