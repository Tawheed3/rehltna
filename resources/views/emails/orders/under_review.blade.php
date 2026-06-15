<!DOCTYPE html>
@php
    $lang = app()->getLocale();
    $dir = $lang === 'ar' ? 'rtl' : 'ltr';
    $align = $lang === 'ar' ? 'right' : 'left';
@endphp
<html lang="{{ $lang }}" dir="{{ $dir }}">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            color: #333;
            direction: {{ $dir }};
            text-align: {{ $align }};
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
        }

        .header {
            background-color: #f8f9fa;
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .content {
            padding: 20px 0;
        }

        .footer {
            font-size: 12px;
            color: #777;
            text-align: center;
            margin-top: 20px;
        }
    </style>
    <title>{{ __('review_mail.title') }}</title>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>{{ __('review_mail.header') }}</h2>
    </div>
    <div class="content">
        <p>{{ __('review_mail.hello') }} <strong>{{ $order->name }}</strong>,</p>
        <p>{{ __('review_mail.received_msg') }} <strong>#{{ $order->transaction_token }}</strong>.</p>
        <p>{{ __('review_mail.review_msg') }}</p>
        <p>{{ __('review_mail.total_amount') }}: <strong>{{ number_format($order->total_amount, 2) }}</strong></p>
    </div>
    <div class="footer">
        <p>{{ __('review_mail.footer_msg') }}</p>
    </div>
</div>
</body>
</html>
