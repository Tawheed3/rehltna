<!DOCTYPE html>
@php
    $lang = app()->getLocale();
    $dir  = $lang === 'ar' ? 'rtl' : 'ltr';
    $alignLeft  = $lang === 'ar' ? 'right' : 'left';
    $alignRight = $lang === 'ar' ? 'left' : 'right';
@endphp
<html lang="{{ $lang }}" dir="{{ $dir }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ __('invoice.title') }}</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            color: #333;
            direction: {{ $dir }};
            text-align: {{ $alignLeft }};
        }
        .wrapper { width: 100%; padding: 30px 15px; background-color: #f0f4f8; }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            padding: 40px 35px;
            text-align: center;
            color: #fff;
        }
        .header .emoji { font-size: 48px; margin-bottom: 12px; }
        .header h1 { font-size: 26px; font-weight: 800; margin-bottom: 6px; letter-spacing: -0.5px; }
        .header p { font-size: 14px; opacity: 0.8; }
        .badge-paid {
            display: inline-block;
            background: #10b981;
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 20px;
            margin-top: 14px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* Body */
        .body { padding: 35px; }

        .greeting { font-size: 16px; margin-bottom: 8px; }
        .greeting strong { color: #1e293b; }
        .intro { font-size: 14px; color: #64748b; margin-bottom: 28px; line-height: 1.6; }

        /* Points Banner */
        .points-banner {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            border: 2px solid #f59e0b;
            border-radius: 12px;
            padding: 20px 24px;
            margin-bottom: 28px;
            text-align: center;
        }
        .points-banner .points-icon { font-size: 32px; margin-bottom: 6px; }
        .points-banner .points-label { font-size: 13px; color: #92400e; font-weight: 600; margin-bottom: 4px; }
        .points-banner .points-value { font-size: 36px; font-weight: 800; color: #b45309; }
        .points-banner .points-sub { font-size: 12px; color: #92400e; margin-top: 4px; }

        /* Section title */
        .section-title {
            font-size: 13px;
            font-weight: 800;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin-bottom: 12px;
        }

        /* Order Items Table */
        .items-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .items-table th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            padding: 10px 14px;
            border-bottom: 2px solid #e2e8f0;
            text-align: {{ $alignLeft }};
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        .items-table td {
            padding: 12px 14px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
            color: #334155;
            vertical-align: middle;
        }
        .items-table tr:last-child td { border-bottom: none; }
        .item-name { font-weight: 700; color: #1e293b; }
        .item-meta { font-size: 12px; color: #94a3b8; margin-top: 2px; }

        /* Totals */
        .totals {
            border-top: 2px solid #e2e8f0;
            padding-top: 16px;
            margin-bottom: 28px;
        }
        .totals-row {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            color: #64748b;
            margin-bottom: 8px;
        }
        .totals-row.discount { color: #ef4444; }
        .totals-row.grand-total {
            font-size: 17px;
            font-weight: 800;
            color: #1e293b;
            border-top: 1px solid #e2e8f0;
            padding-top: 12px;
            margin-top: 4px;
        }

        /* Footer */
        .footer {
            background: #f8fafc;
            padding: 24px 35px;
            text-align: center;
            border-top: 1px solid #e2e8f0;
        }
        .footer p { font-size: 12px; color: #94a3b8; line-height: 1.6; }
        .footer .order-ref { font-size: 11px; color: #cbd5e1; margin-top: 8px; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="container">

        {{-- Header --}}
        <div class="header">
            <div class="emoji">🎉</div>
            <h1>{{ __('invoice.payment_successful') }}</h1>
            <p>{{ __('invoice.intro_msg') }}</p>
            <span class="badge-paid">{{ __('invoice.status_paid') }}</span>
        </div>

        {{-- Body --}}
        <div class="body">

            <p class="greeting">{{ __('invoice.hello') }} <strong>{{ $order->name }}</strong>,</p>
            <p class="intro">
                @if($lang === 'ar')
                    يسعدنا إبلاغك بأن دفعتك تم تأكيدها بنجاح. فيما يلي ملخص طلبك الكامل.
                @else
                    We're thrilled to confirm that your payment has been approved. Below is a summary of your order.
                @endif
            </p>

            {{-- Points Banner --}}
            @if($earnedPoints > 0)
            <div class="points-banner">
                <div class="points-icon">⭐</div>
                <div class="points-label">
                    @if($lang === 'ar') نقاط مكتسبة من هذا الطلب @else Points earned from this order @endif
                </div>
                <div class="points-value">+{{ number_format($earnedPoints) }}</div>
                <div class="points-sub">
                    @if($lang === 'ar')
                        يمكنك استخدام نقاطك في حجزك القادم
                    @else
                        You can use your points on your next booking
                    @endif
                </div>
            </div>
            @endif

            {{-- Order Items --}}
            @if($order->items && $order->items->count() > 0)
            <div class="section-title">
                @if($lang === 'ar') تفاصيل الطلب @else Order Details @endif
            </div>
            <table class="items-table">
                <thead>
                    <tr>
                        <th>@if($lang === 'ar') الرحلة @else Trip @endif</th>
                        <th>@if($lang === 'ar') الأشخاص @else Attendees @endif</th>
                        <th>@if($lang === 'ar') السعر / شخص @else Price / Person @endif</th>
                        <th>@if($lang === 'ar') الإجمالي @else Total @endif</th>
                    </tr>
                </thead>
                <tbody>
                @foreach($order->items as $item)
                    @php
                        $itemName = optional($item->item)->{'title_' . $lang} ?? optional($item->item)->title_en ?? 'Item #' . $item->item_id;
                        $varTitle = $lang === 'ar' ? $item->variation_title_ar : $item->variation_title_en;
                    @endphp
                    <tr>
                        <td>
                            <div class="item-name">{{ $itemName }}</div>
                            @if($varTitle)
                                <div class="item-meta">{{ $varTitle }}</div>
                            @endif
                        </td>
                        <td>{{ $item->attendees_count }}</td>
                        <td>{{ number_format($item->price_per_unit, 2) }} SAR</td>
                        <td><strong>{{ number_format($item->total, 2) }} SAR</strong></td>
                    </tr>
                @endforeach
                </tbody>
            </table>
            @endif

            {{-- Totals --}}
            <div class="totals">
                @if($order->items && $order->items->count() > 0)
                <div class="totals-row">
                    <span>@if($lang === 'ar') المجموع الفرعي @else Subtotal @endif</span>
                    <span>{{ number_format($order->sub_total, 2) }} SAR</span>
                </div>
                @endif
                @if($order->discount_amount > 0)
                <div class="totals-row discount">
                    <span>@if($lang === 'ar') الخصم @else Discount @endif</span>
                    <span>- {{ number_format($order->discount_amount, 2) }} SAR</span>
                </div>
                @endif
                <div class="totals-row grand-total">
                    <span>@if($lang === 'ar') المبلغ المدفوع @else Total Paid @endif</span>
                    <span>{{ number_format($order->total_amount, 2) }} SAR</span>
                </div>
            </div>

        </div>

        {{-- Footer --}}
        <div class="footer">
            <p>@if($lang === 'ar') شكراً لثقتك بنا. نتطلع إلى خدمتك مجدداً! @else Thank you for choosing us. We look forward to serving you again! @endif</p>
            <p class="order-ref">
                @if($lang === 'ar') مرجع الطلب @else Order Ref @endif: #{{ $order->transaction_token }}
                &nbsp;|&nbsp;
                {{ $order->created_at->format('Y-m-d H:i') }}
            </p>
        </div>

    </div>
</div>
</body>
</html>
