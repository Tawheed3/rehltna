<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\Review;
use App\Services\ActivityLogger;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index(Request $request)
    {
        $query = Review::with('item')->latest();

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('search')) {
            $query->where('reviewer_name', 'like', '%' . $request->search . '%');
        }

        $reviews = $query->paginate(20)->withQueryString();
        $items   = Item::select('id', 'title_ar', 'title_en', 'season')->orderBy('title_ar')->get();

        return view('pages.reviews.index', compact('reviews', 'items'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'item_id'       => 'nullable|integer|exists:items,id',
            'reviewer_name' => 'required|string|max:255',
            'rating'        => 'required|integer|min:1|max:5',
            'comment'       => 'nullable|string|max:1000',
        ]);

        Review::create([
            'item_id'          => $request->item_id ?: null,
            'user_id'          => null,
            'reviewer_name'    => $request->reviewer_name,
            'rating'           => $request->rating,
            'comment'          => $request->comment,
            'status'           => 'approved',
            'is_admin_created' => true,
        ]);

        return redirect()->route('reviews.index')->with('success', 'Review created successfully.');
    }

    public function update(Request $request, int $id)
    {
        $request->validate([
            'item_id'       => 'nullable|integer|exists:items,id',
            'reviewer_name' => 'required|string|max:255',
            'rating'        => 'required|integer|min:1|max:5',
            'comment'       => 'nullable|string|max:1000',
            'status'        => 'required|in:pending,approved,rejected',
        ]);

        Review::findOrFail($id)->update([
            'item_id'       => $request->item_id ?: null,
            'reviewer_name' => $request->reviewer_name,
            'rating'        => $request->rating,
            'comment'       => $request->comment,
            'status'        => $request->status,
        ]);

        return redirect()->route('reviews.index')->with('success', 'Review updated successfully.');
    }

    public function approve(int $id)
    {
        $review = Review::findOrFail($id);
        $review->update(['status' => 'approved']);
        ActivityLogger::log('approved', "Review by \"{$review->reviewer_name}\" was approved.", 'Review', $id);
        return back()->with('success', 'Review approved.');
    }

    public function reject(int $id)
    {
        $review = Review::findOrFail($id);
        $review->update(['status' => 'rejected']);
        ActivityLogger::log('rejected', "Review by \"{$review->reviewer_name}\" was rejected.", 'Review', $id);
        return back()->with('success', 'Review rejected.');
    }

    public function destroy(int $id)
    {
        $review = Review::findOrFail($id);
        ActivityLogger::log('deleted', "Review by \"{$review->reviewer_name}\" was deleted.", 'Review', $id);
        $review->delete();
        return back()->with('success', 'Review deleted.');
    }
}
