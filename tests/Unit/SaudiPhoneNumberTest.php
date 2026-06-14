<?php

namespace Tests\Unit;

use App\Support\SaudiPhoneNumber;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

class SaudiPhoneNumberTest extends TestCase
{
    #[DataProvider('validNumbers')]
    public function test_it_normalizes_saudi_mobile_numbers(string $input): void
    {
        $this->assertSame('+966512345678', SaudiPhoneNumber::canonicalize($input));
    }

    public static function validNumbers(): array
    {
        return [
            ['+966512345678'],
            ['00966512345678'],
            ['966512345678'],
            ['0512345678'],
            ['512345678'],
            ['+966 51 234 5678'],
            ['00966-51-234-5678'],
            ['٠٠٩٦٦٥١٢٣٤٥٦٧٨'],
            ['+۹۶۶۵۱۲۳۴۵۶۷۸'],
        ];
    }

    #[DataProvider('invalidNumbers')]
    public function test_it_rejects_non_saudi_or_invalid_numbers(string $input): void
    {
        $this->assertNull(SaudiPhoneNumber::canonicalize($input));
    }

    public static function invalidNumbers(): array
    {
        return [
            [''],
            ['+201012345678'],
            ['01012345678'],
            ['+966112345678'],
            ['+96651234567'],
            ['+9665123456789'],
        ];
    }
}
