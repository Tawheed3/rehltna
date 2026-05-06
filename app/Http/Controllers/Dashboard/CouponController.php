<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Coupon;
use App\Models\Item;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CouponController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): View
    {
        $coupons = Coupon::with('items')->withCount('orders')->latest()->paginate(10);
        return view('pages.coupons.index', compact('coupons'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(): View
    {
        $items = Item::select('id', 'title_ar', 'title_en', 'season')->orderBy('title_ar')->get();

        return view('pages.coupons.create', compact('items'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request): RedirectResponse
    {
        try {

            $request->validate([
                'code' => 'required|string|unique:coupons,code',
                'type' => 'required|in:fixed,percent',
                'value' => 'required|numeric',
                'items' => 'nullable|array',
                'items.*' => 'exists:items,id',
                'status' => 'required|boolean',
            ]);

            $coupon = Coupon::query()->create($request->except('items'));

            if ($request->has('items')) {
                $coupon->items()->attach($request->get('items'));
            }

            return redirect()->route('coupons.index')->with('success', 'Coupon created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong')->withInput();
        }
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id): View
    {
        $coupon = Coupon::with('items')->findOrFail(decrypt($id));
        $items = Item::select('id', 'title_ar', 'title_en', 'season')->orderBy('title_ar')->get();
        $selectedItems = $coupon->items->pluck('id')->toArray();
        return view('pages.coupons.edit', compact('coupon', 'items', 'selectedItems'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id): RedirectResponse
    {
        try {

            $coupon = Coupon::query()->findOrFail($id);

            $request->validate([
                'code' => 'required|string|unique:coupons,code,' . $coupon->id,
                'items' => 'nullable|array',
                'items.*' => 'exists:items,id',
                'type' => 'required|in:fixed,percent',
                'value' => 'required|numeric',
                'status' => 'required|boolean',
            ]);

            $coupon->update($request->except('items'));
            $coupon->items()->sync($request->items ?? []);
            return redirect()->route('coupons.index')->with('success', 'Coupon updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id): RedirectResponse
    {
        try {
            $coupon = Coupon::query()->findOrFail($id);
            $coupon->delete();
            return redirect()->route('coupons.index')->with('success', 'Coupon deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    /**
     * Change Status via AJAX
     */
    public function changeStatus($id): JsonResponse
    {
        $coupon = Coupon::query()->findOrFail($id);
        $coupon->status = !$coupon->status;
        $coupon->save();
        return response()->json(['status' => $coupon->status]);
    }
}
