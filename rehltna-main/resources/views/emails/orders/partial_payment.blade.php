<!DOCTYPE html>
@php
    $lang = app()->getLocale();
    $dir = $lang === 'ar' ? 'rtl' : 'ltr';
    $alignLeft = $lang === 'ar' ? 'right' : 'left';
    $alignRight = $lang === 'ar' ? 'left' : 'right';
    app()->setLocale($lang);
@endphp
<html lang="{{ $lang }}" dir="{{ $dir }}">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            direction: {{ $dir }};
            text-align: {{ $alignLeft }};
            background-color: #f6f6f6;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 100%;
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .header {
            text-align: center;
            border-bottom: 2px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }

        .details {
            margin-bottom: 20px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: {{ $alignLeft }};
        }

        .table th {
            background-color: #f4f4f4;
            color: #243C56;
        }

        .text-right {
            text-align: {{ $alignRight }};
        }

        .amount-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed #eee;
        }

        .amount-row:last-child {
            border-bottom: none;
        }

        .total-box {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #eee;
            margin-top: 20px;
        }

        .footer {
            text-align: center;
            font-size: 12px;
            color: #777;
            margin-top: 30px;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            font-size: 14px;
            font-weight: bold;
            color: #fff;
            background-color: #ffc107;
            border-radius: 4px;
            text-decoration: none;
        }

        .btn {
            display: inline-block;
            background-color: #243C56;
            color: #fff;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            font-weight: bold;
        }

        .text-danger {
            color: #dc3545;
        }

        .text-success {
            color: #28a745;
        }
    </style>
    <title>{{ __('partial.email_title') }}</title>
</head>
<body>
<div class="container">
    <div class="header">
        <h2 style="color: #243C56;">{{ __('partial.email_header') }}</h2>
        <p style="color: #777;">{{ __('invoice.order_id') }} #{{ $order->transaction_token }}</p>
        <span class="badge">{{ __('partial.status_partial') }}</span>
    </div>

    <div class="details">
        <p><strong>{{ __('invoice.hello') }} {{ $order->name }},</strong></p>
        <p>{{ __('partial.intro_msg') }}</p>
    </div>

    <table class="table">
        <thead>
        <tr>
            <th>{{ __('partial.description') }}</th>
            <th class="text-right">{{ __('partial.amount') }}</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>{{ __('partial.total_required') }}</td>
            <td class="text-right">{{ number_format($totalRequired, 2) }}</td>
        </tr>
        <tr>
            <td>{{ __('partial.paid_now') }}</td>
            <td class="text-right text-success">
                <strong>- {{ number_format($order->total_amount, 2) }}</strong>
            </td>
        </tr>
        <tr style="background-color: #fff5f5;">
            <td><strong>{{ __('partial.remaining_amount') }}</strong></td>
            <td class="text-right text-danger">
                <strong>{{ number_format($remainingAmount, 2) }}</strong>
            </td>
        </tr>
        </tbody>
    </table>

    <div style="text-align: center; margin: 30px 0;">
        <p style="font-size: 14px; color: #666; margin-bottom: 15px;">{{ __('partial.complete_payment_msg') }}</p>
        <a href="{{ route('home') }}" class="btn">{{ __('partial.btn_complete_payment') }}</a>
    </div>

    <div class="footer">
        <p>{{ __('invoice.date') }}: {{ $order->created_at->format('Y-m-d H:i') }}</p>
        <p>{{ __('invoice.footer_contact') }}</p>
        <p>&copy; {{ date('Y') }} {{ get_setting('site_name_'.$lang) }}</p>
    </div>
</div>
</body>
</html>
