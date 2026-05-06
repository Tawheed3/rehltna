<!DOCTYPE html>
<html lang="en" dir="ltr">
<head>
<meta charset="UTF-8">
<title>Order Needs Review</title>
<style>
    body { font-family: Arial, sans-serif; background: #f1f5f9; margin: 0; padding: 30px 0; }
    .wrap { max-width: 580px; margin: 0 auto; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
    .top-bar { background: #f59e0b; height: 5px; }
    .header { background: #1e293b; padding: 28px 32px; text-align: center; }
    .header h1 { color: #fff; font-size: 20px; margin: 0 0 4px; }
    .header p { color: #94a3b8; font-size: 13px; margin: 0; }
    .body { padding: 28px 32px; }
    .alert-box { background: #fffbeb; border: 1.5px solid #fde68a; border-left: 4px solid #f59e0b; border-radius: 8px; padding: 14px 18px; margin-bottom: 22px; }
    .alert-box p { margin: 0; font-size: 14px; color: #92400e; font-weight: 600; }
    .info-table { width: 100%; border-collapse: collapse; margin-bottom: 22px; }
    .info-table tr { border-bottom: 1px solid #f1f5f9; }
    .info-table tr:last-child { border-bottom: none; }
    .info-table td { padding: 10px 4px; font-size: 13px; vertical-align: top; }
    .info-table td:first-child { color: #94a3b8; font-weight: 600; width: 38%; }
    .info-table td:last-child { color: #1e293b; font-weight: 700; }
    .badge { display: inline-block; background: #fef3c7; color: #92400e; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
    .btn { display: inline-block; background: #4f46e5; color: #fff !important; text-decoration: none; padding: 13px 28px; border-radius: 8px; font-size: 14px; font-weight: 700; margin-top: 8px; }
    .footer { background: #f8fafc; padding: 16px 32px; text-align: center; font-size: 11px; color: #94a3b8; border-top: 1px solid #e2e8f0; }
</style>
</head>
<body>
<div class="wrap">
    <div class="top-bar"></div>

    <div class="header">
        <h1>🔔 New Receipt — Action Required</h1>
        <p>A customer has uploaded a payment receipt and is waiting for your approval.</p>
    </div>

    <div class="body">
        <div class="alert-box">
            <p>Order <strong>#{{ $order->id }}</strong> is now under review. Please verify the receipt and approve or reject the order as soon as possible.</p>
        </div>

        <table class="info-table">
            <tr>
                <td>Order #</td>
                <td>#{{ $order->id }}</td>
            </tr>
            <tr>
                <td>Customer</td>
                <td>{{ $order->name }}</td>
            </tr>
            <tr>
                <td>Email</td>
                <td>{{ $order->email }}</td>
            </tr>
            <tr>
                <td>Phone</td>
                <td>{{ $order->phone }}</td>
            </tr>
            <tr>
                <td>Sub Total</td>
                <td>{{ number_format($order->sub_total, 2) }} SAR</td>
            </tr>
            @if($order->used_points > 0)
            <tr>
                <td>Points Used</td>
                <td>{{ number_format($order->used_points) }} pts → -{{ number_format($order->used_points / 50, 2) }} SAR</td>
            </tr>
            @endif
            @if($order->coupon_id && $order->coupon)
            <tr>
                <td>Coupon</td>
                <td>{{ $order->coupon->code }} → -{{ number_format($order->discount_amount - ($order->used_points / 50), 2) }} SAR</td>
            </tr>
            @endif
            <tr>
                <td>Total Amount</td>
                <td>{{ number_format($order->total_amount, 2) }} SAR</td>
            </tr>
            <tr>
                <td>Payment Method</td>
                <td>{{ ucwords(str_replace('_', ' ', $order->payment_method)) }}</td>
            </tr>
            @if($order->items->isNotEmpty())
            <tr>
                <td>Trip(s)</td>
                <td>
                    @foreach($order->items as $orderItem)
                        @php $trip = $orderItem->item; @endphp
                        <div style="margin-bottom:10px;padding:10px 12px;background:#f8fafc;border-radius:8px;border:1px solid #e2e8f0;direction:rtl;text-align:right;">
                            <div style="font-weight:800;font-size:14px;color:#1e293b;margin-bottom:4px;">
                                {{ $trip?->title_ar ?? $trip?->title_en ?? 'رحلة #' . $orderItem->item_id }}
                            </div>
                            @if($trip?->start_date || $trip?->end_date)
                                <div style="font-size:12px;color:#64748b;margin-bottom:4px;">
                                    📅
                                    @if($trip->start_date)
                                        {{ \Carbon\Carbon::parse($trip->start_date)->format('d M Y') }}
                                        @if($trip->start_date_hijri) ({{ $trip->start_date_hijri }}) @endif
                                    @endif
                                    @if($trip->end_date)
                                        — {{ \Carbon\Carbon::parse($trip->end_date)->format('d M Y') }}
                                        @if($trip->end_date_hijri) ({{ $trip->end_date_hijri }}) @endif
                                    @endif
                                </div>
                            @endif
                            <div style="font-size:12px;color:#475569;margin-bottom:6px;">
                                <strong>الحضور:</strong>
                                {{ $orderItem->variation_title_ar ?: $orderItem->variation_title_en ?: '#'.$orderItem->item_price_id }}
                                — {{ $orderItem->attendees_count }} شخص
                                ({{ number_format($orderItem->price_per_unit, 2) }} SAR × {{ $orderItem->attendees_count }}
                                = {{ number_format($orderItem->total, 2) }} SAR)
                            </div>
                            @if($trip?->whatsapp)
                                @php
                                    $wa = preg_replace('/\D/', '', $trip->whatsapp);
                                    if (substr($wa, 0, 2) !== '96') $wa = '966' . ltrim($wa, '0');
                                @endphp
                                <a href="https://wa.me/{{ $wa }}"
                                   style="display:inline-block;background:#25d366;color:#fff;text-decoration:none;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700;">
                                    &#128222; WhatsApp
                                </a>
                            @endif
                        </div>
                    @endforeach
                </td>
            </tr>
            @endif
            <tr>
                <td>Status</td>
                <td><span class="badge">Awaiting Review</span></td>
            </tr>
            <tr>
                <td>Submitted At</td>
                <td>{{ now()->format('d M Y, h:i A') }}</td>
            </tr>
        </table>

        <a href="{{ url('/admin/orders') }}" class="btn">Open Orders Dashboard →</a>
    </div>

    <div class="footer">
        This is an automated notification from Rehltna Dashboard. Do not reply to this email.
    </div>
</div>
</body>
</html>
