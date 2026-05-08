<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Mail\OrderInvoiceMail;
use App\Mail\OrderRejectedMail;
use App\Models\Order;
use App\Models\PointLog;
use App\Models\ResidencyUser;
use App\Services\ActivityLogger;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\View\View;

class OrderController extends Controller
{
    public function index(Request $request): View|string
    {
        $query = Order::with(['items', 'coupon']);

        $query->when($request->filled('search'), function ($q) use ($request) {
            $search = $request->get('search');
            $q->where(function ($subQ) use ($search) {
                $subQ->where('email', 'like', "%{$search}%")
                    ->orWhere('name', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        });

        $query->when($request->filled('payment_method'), function ($q) use ($request) {
            $q->where('payment_method', $request->get('payment_method'));
        });

        $query->when($request->filled('payment_status'), function ($q) use ($request) {
            $q->where('payment_status', $request->get('payment_status'));
        });

        $query->when($request->filled('start_date'), function ($q) use ($request) {
            $q->whereDate('created_at', '>=', $request->get('start_date'));
        });

        $query->when($request->filled('end_date'), function ($q) use ($request) {
            $q->whereDate('created_at', '<=', $request->get('end_date'));
        });

        $orders = $query->latest()->paginate(10);

        if ($request->ajax()) {
            return view('pages.orders.partials.table', compact('orders'))->render();
        }

        return view('pages.orders.index', compact('orders'));
    }

    public function show($id): View
    {
        $order = Order::with(['items.item', 'coupon'])->findOrFail(decrypt($id));
        return view('pages.orders.show', compact('order'));
    }

    public function updateStatus(Request $request, $id): RedirectResponse
    {
        $request->validate([
            'payment_status' => 'required|in:paid,rejected'
        ]);

        try {

            $order = Order::query()->with('items')->findOrFail($id);

            $previousStatus = $order->payment_status;

            $order->update([
                'payment_status' => $request->get('payment_status')
            ]);

            if ($order->paymentLink) {
                $order->paymentLink->update([
                    'status' => $request->get('payment_status')
                ]);
            }

            // Guard against processing an already-paid order twice
            if ($request->get('payment_status') === 'paid' && $previousStatus !== 'paid') {
                try {
                    $order->load(['items', 'user']);

                    $user = $order->user;

                    if ($user) {

                        foreach ($order->items as $orderItem) {

                            $existing = DB::table('item_residency_users')
                                ->where('residency_user_id', $user->id)
                                ->where('item_id', $orderItem->item_id)
                                ->first();

                            if ($existing) {

                                DB::table('item_residency_users')
                                    ->where('id', $existing->id)
                                    ->update([
                                        'attendees' => (int)$existing->attendees + (int)$orderItem->attendees_count,
                                        'updated_at' => now()
                                    ]);

                            } else {

                                DB::table('item_residency_users')->insert([
                                    'residency_user_id' => $user->id,
                                    'item_id' => $orderItem->item_id,
                                    'attendees' => $orderItem->attendees_count,
                                    'created_at' => now(),
                                    'updated_at' => now(),
                                ]);

                            }
                        }

                        $tripName = optional($order->items->first()?->item)->title_en ?? 'Trip #' . $order->id;

                        // Deduct used points now (bank transfer orders: points held at checkout, deducted on admin approval)
                        $alreadyDeducted = PointLog::where('order_id', $order->id)->where('type', 'trip_used')->exists();
                        if (!$alreadyDeducted && $order->used_points > 0) {
                            $balanceBefore = (int) $user->available_points;
                            $user->decrement('available_points', $order->used_points);
                            PointLog::create([
                                'residency_user_id' => $user->id,
                                'type'              => 'trip_used',
                                'points'            => -(int) $order->used_points,
                                'balance_before'    => $balanceBefore,
                                'balance_after'     => $balanceBefore - (int) $order->used_points,
                                'order_id'          => $order->id,
                                'trip_name'         => $tripName,
                            ]);
                        }

                        // 1 SAR spent = 1 point earned (based on final amount paid after all discounts)
                        $earnedPoints = (int) $order->total_amount;
                        if ($earnedPoints > 0) {
                            $balanceBefore = (int) $user->available_points;
                            $user->increment('earned_points', $earnedPoints);
                            $user->increment('available_points', $earnedPoints);

                            PointLog::create([
                                'residency_user_id' => $user->id,
                                'type'              => 'trip_earned',
                                'points'            => $earnedPoints,
                                'balance_before'    => $balanceBefore,
                                'balance_after'     => $balanceBefore + $earnedPoints,
                                'order_id'          => $order->id,
                                'trip_name'         => $tripName,
                            ]);
                        }

                    }

                } catch (\Exception $e) {
                    Log::error('Points Calculation Error: ' . $e->getMessage());
                }

                try {
                    $order->load('items.item');
                    $earnedPoints = (int) $order->total_amount;
                    Mail::to($order->email)->send(new OrderInvoiceMail($order, $earnedPoints));
                } catch (\Exception $e) {
                    Log::error('Mail sending failed: ' . $e->getMessage());
                }

            } elseif ($request->get('payment_status') === 'rejected') {

                // Refund points if they were already deducted (handles orders placed before this fix)
                $order->load('user');
                $user = $order->user;
                if ($user && $order->used_points > 0) {
                    $wasDeducted = PointLog::where('order_id', $order->id)->where('type', 'trip_used')->exists();
                    if ($wasDeducted) {
                        $balanceBefore = (int) $user->available_points;
                        $user->increment('available_points', $order->used_points);
                        PointLog::create([
                            'residency_user_id' => $user->id,
                            'type'              => 'employee_adjusted',
                            'points'            => (int) $order->used_points,
                            'balance_before'    => $balanceBefore,
                            'balance_after'     => $balanceBefore + (int) $order->used_points,
                            'order_id'          => $order->id,
                            'reason'            => 'Points refunded — Order #' . $order->id . ' rejected',
                            'employee_name'     => auth()->user()->name ?? 'Admin',
                        ]);
                    }
                }

                try {
                    Mail::to($order->email)->send(new OrderRejectedMail($order));
                } catch (\Exception $e) {
                    Log::error('Rejected Mail Error: ' . $e->getMessage());
                }
            }

            $statusLabel = $request->get('payment_status') === 'paid' ? 'approved' : 'rejected';
            ActivityLogger::log($statusLabel, "Order #{$order->id} was {$statusLabel}.", 'Order', $order->id);

            return redirect()->back()->with('success', 'Order status updated successfully.');

        } catch (\Exception $e) {
            Log::error("Error updating order status: " . $e->getMessage());
            return redirect()->back()->with('error', 'Something went wrong: ' . $e->getMessage());
        }
    }

    public function destroy($id): RedirectResponse
    {
        try {

            $order = Order::query()->findOrFail($id);
            deleteFiles([$order->payment_proof]);
            $order->delete();

            ActivityLogger::log('deleted', "Order #{$id} was deleted.", 'Order', $id);

            return redirect()->route('orders.index')->with('success', 'Order deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Something went wrong');
        }
    }
}
