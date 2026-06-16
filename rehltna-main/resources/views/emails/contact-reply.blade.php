<!DOCTYPE html>
@php
    $lang = app()->getLocale();
    $dir = $lang === 'ar' ? 'rtl' : 'ltr';
    $align = $lang === 'ar' ? 'right' : 'left';
    $borderSide = $lang === 'ar' ? 'right' : 'left';
    $siteName = get_setting('site_name_' . $lang) ?? config('app.name');
@endphp
<html lang="{{ $lang }}" dir="{{ $dir }}" style="margin: 0; padding: 0; box-sizing: border-box;">
<head>
    <meta charset="UTF-8">
    <title>{{ __('contact_reply.subject_reply') }} {{ $siteName }}</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; background-color: #f4f6f8; direction: {{ $dir }}; text-align: {{ $align }};">

<table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 640px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); overflow: hidden; direction: {{ $dir }};">
    <tr>
        <td style="background-color: #0d6efd; padding: 20px 30px; text-align: center;">
            <h1 style="margin: 0; color: #fff; font-size: 24px;">{{ $siteName }}</h1>
        </td>
    </tr>
    <tr>
        <td style="padding: 30px; text-align: {{ $align }};">
            <h2 style="color: #2c3e50; margin-top: 0;">{{ __('contact_reply.hello') }} {{ $contact->name }},</h2>

            <p style="color: #555; font-size: 16px; line-height: 1.6;">
                {{ __('contact_reply.intro') }}
            </p>

            <div style="margin: 20px 0; background-color: #f1f7ff; border-{{ $borderSide }}: 5px solid #0d6efd; padding: 15px 20px; border-radius: 5px; font-style: italic; color: #333;">
                {{ $reply }}
            </div>

            <p style="color: #555; font-size: 16px; line-height: 1.6;">
                {{ __('contact_reply.outro') }}
            </p>

            <p style="margin-top: 30px; color: #2c3e50;">
                {{ __('contact_reply.regards') }},<br>
                <strong>{{ $siteName }} {{ __('contact_reply.team') }}</strong>
            </p>
        </td>
    </tr>
    <tr>
        <td style="background-color: #f8f9fa; text-align: center; padding: 20px; font-size: 13px; color: #999;">
            {{ __('contact_reply.footer_note') }}
        </td>
    </tr>
</table>

</body>
</html>
