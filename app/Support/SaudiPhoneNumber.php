<?php

namespace App\Support;

class SaudiPhoneNumber
{
    public static function canonicalize(string $input): ?string
    {
        $input = strtr($input, [
            '٠' => '0', '١' => '1', '٢' => '2', '٣' => '3', '٤' => '4',
            '٥' => '5', '٦' => '6', '٧' => '7', '٨' => '8', '٩' => '9',
            '۰' => '0', '۱' => '1', '۲' => '2', '۳' => '3', '۴' => '4',
            '۵' => '5', '۶' => '6', '۷' => '7', '۸' => '8', '۹' => '9',
        ]);

        $digits = preg_replace('/\D+/', '', $input) ?? '';

        if (str_starts_with($digits, '00966')) {
            $digits = substr($digits, 5);
        } elseif (str_starts_with($digits, '966')) {
            $digits = substr($digits, 3);
        } elseif (str_starts_with($digits, '0')) {
            $digits = substr($digits, 1);
        }

        if (preg_match('/^5\d{8}$/', $digits) !== 1) {
            return null;
        }

        return '+966'.$digits;
    }
}
