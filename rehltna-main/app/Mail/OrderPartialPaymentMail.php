<?php

namespace App\Mail;

use App\Models\Order;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class OrderPartialPaymentMail extends Mailable
{
    use Queueable, SerializesModels;

    public $order;
    public $remainingAmount;
    public $totalRequired;

    public function __construct(Order $order)
    {
        $this->order = $order;
        if ($order->paymentLink) {
            $this->totalRequired = $order->paymentLink->amount;
            $this->remainingAmount = $this->totalRequired - $order->total_amount;
        } else {
            $this->totalRequired = $order->total_amount;
            $this->remainingAmount = 0;
        }
    }

    public function build()
    {
        $lang = app()->getLocale();
        app()->setLocale($lang);
        return $this->subject(__('partial.email_title') . ' - ' . get_setting('site_name_' . $lang))
            ->view('emails.orders.partial_payment');
    }
}
