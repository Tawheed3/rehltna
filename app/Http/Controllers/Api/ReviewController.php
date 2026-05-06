<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Traits\ResponseTrait;
use App\Mail\NewReviewMail;
use App\Models\Review;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class ReviewController extends Controller
{
    use ResponseTrait;

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'item_id' => 'required|integer|exists:items,id',
            'rating'  => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        $user = $request->user();

        $exists = Review::where('user_id', $user->id)
            ->where('item_id', $request->item_id)
            ->exists();

        if ($exists) {
            return $this->responseMessage(422, 'You have already submitted a review for this trip.');
        }

        $review = Review::create([
            'item_id'          => $request->item_id,
            'user_id'          => $user->id,
            'reviewer_name'    => $user->name,
            'rating'           => $request->rating,
            'comment'          => $request->comment,
            'status'           => 'pending',
            'is_admin_created' => false,
        ]);

        try {
            $adminEmail = get_setting('contact_email') ?: config('mail.from.address');
            Mail::to($adminEmail)->send(new NewReviewMail($review));
        } catch (\Exception $e) {
            // mail failure does not block the response
        }

        return $this->responseMessage(201, 'Review submitted successfully. It will appear after approval.', $review);
    }

    public function index(int $itemId): JsonResponse
    {
        $reviews = Review::where('item_id', $itemId)
            ->where('status', 'approved')
            ->orderByDesc('created_at')
            ->get(['reviewer_name', 'rating', 'comment', 'created_at']);

        return $this->responseMessage(200, 'Reviews fetched successfully.', $reviews);
    }
}
