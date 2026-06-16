<!DOCTYPE html>
@php
    $lang = app()->getLocale();
    $dir = $lang === 'ar' ? 'rtl' : 'ltr';
    $align = $lang === 'ar' ? 'right' : 'left';
    $borderSide = $lang === 'ar' ? 'right' : 'left';
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
            border-{{ $borderSide }}: 5px solid #dc3545; /* Dynamic Border Side */
        }

        .header {
            padding: 10px;
            border-bottom: 1px solid #eee;
        }

        .content {
            padding: 20px 0;
        }

        .alert {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
    <title>{{ __('payment_rejected.title') }}</title>
</head>
<body>
<div class="container">
    <div class="header">
        <h2 style="color: #dc3545;">{{ __('payment_rejected.header') }}</h2>
    </div>
    <div class="content">
        <p>{{ __('payment_rejected.hello') }} <strong>{{ $order->name }}</strong>,</p>
        <p>{{ __('payment_rejected.regarding_order') }} <strong>#{{ $order->transaction_token }}</strong>.</p>

        <p class="alert">{{ __('payment_rejected.rejection_msg') }}</p>
        <p>{{ __('payment_rejected.rejection_reason') }}</p>
        <p>{{ __('payment_rejected.action_required') }}</p>
    </div>
    <div class="footer">
        <p>{{ __('payment_rejected.best_regards') }},<br>{{ __('payment_rejected.support_team') }}</p>
    </div>
</div>
</body>
</html>
