<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\Review;
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

    public function approve(int $id)
    {
        Review::findOrFail($id)->update(['status' => 'approved']);
        return back()->with('success', 'Review approved.');
    }

    public function reject(int $id)
    {
        Review::findOrFail($id)->update(['status' => 'rejected']);
        return back()->with('success', 'Review rejected.');
    }

    public function destroy(int $id)
    {
        Review::findOrFail($id)->delete();
        return back()->with('success', 'Review deleted.');
    }
}
