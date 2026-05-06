<?php

namespace App\Mail;

use App\Models\Review;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class NewReviewMail extends Mailable
{
    use Queueable, SerializesModels;

    public Review $review;

    public function __construct(Review $review)
    {
        $this->review = $review->loadMissing('item');
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: '⭐ New Review — ' . $this->review->reviewer_name . ' rated ' . $this->review->rating . '/5 stars',
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.reviews.new_review',
        );
    }
}
