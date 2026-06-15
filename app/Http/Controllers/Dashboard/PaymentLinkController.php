<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Item;
use App\Models\PaymentLink;
use App\Models\RegisterUsers;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class PaymentLinkController extends Controller
{
    public function index(): View
    {
        $links = PaymentLink::query()->latest()->paginate(10);
        return view('pages.payment_links.index', compact('links'));
    }

    public function create(): View
    {
        $items = Item::select('id', 'title_ar', 'title_en', 'season', 'price', 'name')->where('status', 1)->orderBy('title_ar')->get();
        return view('pages.payment_links.create', compact('items'));
    }

    public function store(Request $request): RedirectResponse
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'phone' => 'required|string|max:20',
                'specialty' => 'required|string',
                'country' => 'required|string',
                'link_type' => 'required|in:items,amount',
                'items' => 'required_if:link_type,items|array',
                'items.*.item_id' => ['required_if:link_type,items', 'nullable', Rule::exists(Item::class, 'id')],
                'items.*.attendees' => 'required_if:link_type,items|nullable|integer|min:1',
                'amount' => 'required_if:link_type,amount|nullable|numeric|min:1',
                'note' => 'nullable|string|max:500',
            ]);

            $itemsData = $request->get('link_type') == 'items' ? $request->get('items') : null;
            $amountData = $request->get('link_type') == 'amount' ? $request->get('amount') : null;

            $note = null;
            if ($request->get('link_type') == 'items' && !empty($itemsData)) {
                $itemIds = collect($itemsData)->pluck('item_id');
                $selectedItems = Item::query()->whereIn('id', $itemIds)->get();
                $note = $selectedItems->map(function ($item) {
                    return $item->title_en ?? $item->name;
                })->implode(', ');
            } elseif ($request->get('link_type') == 'amount') {
                $note = $request->get('note');
            }

            PaymentLink::query()->create([
                'uuid' => Str::uuid(),
                'name' => $request->get('name'),
                'email' => $request->get('email'),
                'phone' => $request->get('phone'),
                'specialty' => $request->get('specialty'),
                'country' => $request->get('country'),
                'items' => $itemsData,
                'amount' => $amountData,
                'note' => $note,
                'status' => 'pending'
            ]);

            return redirect()->route('payment-links.index')
                ->with('success', 'Payment Link created successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong: ' . $e->getMessage())->withInput();
        }
    }

    public function edit($id): View
    {
        $link = PaymentLink::query()->findOrFail(decrypt($id));
        if ($link->status == 'paid') {
            abort(403, 'Cannot edit a paid link.');
        }

        if ($link->status == 'partial') {
            abort(403, 'Cannot edit a partial link.');
        }

        if ($link->status == 'reviewing') {
            abort(403, 'Cannot edit a reviewing link.');
        }

        $items = Item::select('id', 'title_ar', 'title_en', 'season', 'price', 'name')->where('status', 1)->orderBy('title_ar')->get();

        return view('pages.payment_links.edit', compact('link', 'items'));
    }

    public function update(Request $request, $id): RedirectResponse
    {
        try {
            $link = PaymentLink::query()->findOrFail($id);

            if ($link->status == 'paid') {
                return redirect()->back()->with('error', 'Cannot update a paid link.');
            }

            if ($link->status == 'partial') {
                return redirect()->back()->with('error', 'Cannot update a partial link.');
            }

            if ($link->status == 'reviewing') {
                return redirect()->back()->with('error', 'Cannot update a reviewing link.');
            }

            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'phone' => 'required|string|max:20',
                'specialty' => 'required|string',
                'country' => 'required|string',
                'link_type' => 'required|in:items,amount',
                'items' => 'required_if:link_type,items|array',
                'items.*.item_id' => ['required_if:link_type,items', 'nullable', Rule::exists(Item::class, 'id')],
                'items.*.attendees' => 'required_if:link_type,items|nullable|integer|min:1',
                'amount' => 'required_if:link_type,amount|nullable|numeric|min:1',
                'note' => 'nullable|string|max:500',
            ]);

            $itemsData = $request->get('link_type') == 'items' ? $request->get('items') : null;
            $amountData = $request->get('link_type') == 'amount' ? $request->get('amount') : null;

            $note = null;
            if ($request->get('link_type') == 'items' && !empty($itemsData)) {
                $itemIds = collect($itemsData)->pluck('item_id');
                $selectedItems = Item::query()->whereIn('id', $itemIds)->get();
                $note = $selectedItems->map(function ($item) {
                    return $item->title_en ?? $item->name;
                })->implode(', ');
            } elseif ($request->get('link_type') == 'amount') {
                $note = $request->get('note');
            }

            $link->update([
                'name' => $request->get('name'),
                'email' => $request->get('email'),
                'phone' => $request->get('phone_code') . $request->get('phone'),
                'specialty' => $request->get('specialty'),
                'country' => $request->get('country'),
                'items' => $itemsData,
                'amount' => $amountData,
                'note' => $note,
            ]);

            return redirect()->route('payment-links.index')->with('success', 'Payment Link updated successfully.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong: ' . $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {
            $link = PaymentLink::query()->findOrFail($id);
            if ($link->status == 'paid') {
                return redirect()->back()->with('error', 'Cannot delete a paid link.');
            }

            if ($link->status == 'partial') {
                return redirect()->back()->with('error', 'Cannot delete a partial link.');
            }

            if ($link->status == 'reviewing') {
                return redirect()->back()->with('error', 'Cannot delete a reviewing link.');
            }
            $link->delete();
            return redirect()->route('payment-links.index')->with('success', 'Payment Link deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Oops! Something went wrong');
        }
    }

    public function storeFromRegisterUser($id): JsonResponse
    {
        try {
            $registerUser = RegisterUsers::query()->findOrFail($id);

            if (!$registerUser->item) {
                return response()->json(['status' => 'error', 'message' => 'User has no item assigned'], 422);
            }

            $uuid = Str::uuid();

            $note = $registerUser->item->title_en ?? $registerUser->item->title_fr;

            PaymentLink::query()->create([
                'uuid' => $uuid,
                'name' => $registerUser->name,
                'email' => $registerUser->email,
                'phone' => $registerUser->phone,
                'specialty' => $registerUser->specialty,
                'country' => $registerUser->country,
                'items' => [
                    [
                        'item_id' => $registerUser->item_id,
                        'attendees' => 1
                    ]
                ],
                'amount' => null,
                'status' => 'pending',
                'note' => $note
            ]);

            $link = route('quick.pay', $uuid);

            return response()->json([
                'status' => 'success',
                'message' => 'Link created successfully',
                'link' => $link
            ]);

        } catch (\Exception $e) {
            return response()->json(['status' => 'error', 'message' => $e->getMessage()], 500);
        }
    }
}
