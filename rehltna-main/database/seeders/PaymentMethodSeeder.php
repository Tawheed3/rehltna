<?php

namespace Database\Seeders;

use App\Models\Tenant;
use Illuminate\Database\Seeder;
use App\Models\PaymentMethod;

class PaymentMethodSeeder extends Seeder
{
    public function run(): void
    {
        $tenantId = Tenant::query()->first()->id;
        $tenant = Tenant::query()->findOrFail($tenantId);
        $tenant->makeCurrent();
        $tenantName = $tenant->name ?? 'Unknown';
        $this->command->info("Seeding Payment Methods for Tenant: {$tenant->id} ({$tenantName})");

        $methods = [
            [
                'title_en' => 'Bank Transfer - AlAhli Bank',
                'title_ar' => 'تحويل بنكي - البنك الأهلي',
                'title_fr' => 'Virement Bancaire - AlAhli',
                'title_de' => 'Banküberweisung - AlAhli',
                'slug_en' => 'bank-transfer-alahli',
                'slug_ar' => 'تحويل-بنكي-الاهلي',
                'slug_fr' => 'virement-bancaire-alahli',
                'slug_de' => 'bank-uberweisung-alahli',
                'code' => 'bank_transfer_alahli',
                'status' => 1,
                'banner_en' => 'payment-methods/alahli.jpeg',
                'banner_ar' => 'payment-methods/alahli.jpeg',
                'banner_fr' => 'payment-methods/alahli.jpeg',
                'banner_de' => 'payment-methods/alahli.jpeg',
                'config' => [
                    'bank_name' => 'البنك الاهلي التجاري',
                    'account_name' => 'مؤسسة رحلتنا لتنظيم الرحلات',
                    'account_number' => '15463733000108',
                    'iban' => 'SA8910000015463733000108',
                    'bank_address' => 'المملكة العربية السعودية',
                    'instructions' => 'الرجاء إرفاق إيصال التحويل بعد إتمام العملية.',
                ],
            ],
            [
                'title_en' => 'Bank Transfer - Al Rajhi Bank',
                'title_ar' => 'تحويل بنكي - بنك الراجحي',
                'title_fr' => 'Virement Bancaire - Al Rajhi',
                'title_de' => 'Banküberweisung - Al Rajhi',
                'slug_en' => 'bank-transfer-alrajhi',
                'slug_ar' => 'تحويل-بنكي-الراجحي',
                'slug_fr' => 'virement-bancaire-alrajhi',
                'slug_de' => 'bank-uberweisung-alrajhi',
                'code' => 'bank_transfer_alrajhi',
                'status' => 1,
                'banner_en' => 'payment-methods/alrajhi.jpg',
                'banner_ar' => 'payment-methods/alrajhi.jpg',
                'banner_fr' => 'payment-methods/alrajhi.jpg',
                'banner_de' => 'payment-methods/alrajhi.jpg',
                'config' => [
                    'bank_name' => 'بنك الراجحى',
                    'account_name' => 'مؤسسة رحلتنا لتنظيم الرحلات',
                    'account_number' => '551608010056607',
                    'iban' => 'SA8680000551608010056607',
                    'bank_address' => 'المملكة العربية السعودية',
                    'instructions' => 'الرجاء إرفاق إيصال التحويل بعد إتمام العملية.',
                ],
            ],
            [
                'title_en' => 'Tamara',
                'title_ar' => 'تمارا',
                'title_fr' => 'Tamara',
                'title_de' => 'Tamara',
                'slug_en' => 'tamara',
                'slug_ar' => 'تمارا',
                'slug_fr' => 'tamara',
                'slug_de' => 'tamara',
                'code' => 'tamara',
                'status' => 1,
                'banner_en' => 'payment-methods/tamara.jpeg',
                'banner_ar' => 'payment-methods/tamara.jpeg',
                'banner_fr' => 'payment-methods/tamara.jpeg',
                'banner_de' => 'payment-methods/tamara.jpeg',
                'config' => [
                    'live' => [
                        'base_url' => 'https://api.tamara.co',
                        'secret_key' => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI3YjQ2ZmM4My1kOTkzLTRkOTktYWFiZC01MDM2MTczMzYzYTIiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiNmI3ZDQxMjQtMjQ1NS00YTc5LTkzZjktNTE5NjU0NTVkY2UzIiwicm9sZXMiOlsiUk9MRV9NRVJDSEFOVCJdLCJpc010bHMiOmZhbHNlLCJpYXQiOjE3NzM0OTI3NzAsImlzcyI6IlRhbWFyYSBQUCJ9.YTxEeRORt7kWXvgquslP3I6CHsYhQAoAFJyKvjau9O1cbrclwo9mtiDgWKAJvppMxEbElG8nNQ6swAQgovK2ZITCC_G_96sxOMZnkhf_KKXBaLZCTltdAN8HYNgt_fz-Iy1BnPE8jDnqsYurDuIs-G7xfM7YQJREABaQr510vl6Bivqo4O6YeIjdW-Fm0_GFwb_7b5Uh2qlC9GrvQoGYtt1Kmf6d5WXSWK2LpPeGBFaLj-S_KHHazGLoypXKpdhOSq0GECLBD-cyVYLytlPgV50OYTqcgzU1Im9AsIxIpJ-K5DImHeyrp4s5hnJC_NKfvQPgwZ8rzOv_pPheTX2pBg',
                        'public_key' => '2824722a-824d-495b-b9fc-617d59652200',
                    ],
                    'test' => [
                        'base_url' => 'https://api-sandbox.tamara.co',
                        'secret_key' => 'sk_test_0190e4e4-432b-0f64-4717-30d5d415747f',
                        'public_key' => 'pk_test_0190e4e4-432b-0f64-4717-30d5109dbe3d',
                    ],
                    'mode' => 'test',
                ],
            ],
            [
                'title_en' => 'Moyasar (Mada, Apple Pay, STC Pay, Visa)',
                'title_ar' => 'ميسر (مدى، أبل باي، STC Pay، فيزا)',
                'title_fr' => 'Moyasar (Mada, Apple Pay, STC Pay)',
                'title_de' => 'Moyasar (Mada, Apple Pay, STC Pay)',
                'slug_en' => 'moyasar',
                'slug_ar' => 'ميسر',
                'slug_fr' => 'moyasar',
                'slug_de' => 'moyasar',
                'code' => 'moyasar',
                'status' => 0,
                'banner_en' => 'payment-methods/moyasar.png',
                'banner_ar' => 'payment-methods/moyasar.png',
                'banner_fr' => 'payment-methods/moyasar.png',
                'banner_de' => 'payment-methods/moyasar.png',
                'config' => [
                    'live' => [
                        'secret_key' => 'sk_live_...',
                        'publishable_key' => 'pk_live_...',
                    ],
                    'test' => [
                        'secret_key' => 'sk_test_...',
                        'publishable_key' => 'pk_test_...',
                    ],
                    'mode' => 'test',
                ],
            ],
            [
                'title_en' => 'Vodafone Cash',
                'title_ar' => 'فودافون كاش',
                'title_fr' => 'Vodafone Cash',
                'title_de' => 'Vodafone Cash',
                'slug_en' => 'vodafone-cash',
                'slug_ar' => 'فودافون-كاش',
                'slug_fr' => 'vodafone-cash',
                'slug_de' => 'vodafone-cash',
                'code' => 'wallet_vodafone',
                'status' => 0,
                'banner_en' => 'payment-methods/vodafone.png',
                'banner_ar' => 'payment-methods/vodafone.png',
                'banner_fr' => 'payment-methods/vodafone.png',
                'banner_de' => 'payment-methods/vodafone.png',
                'config' => [
                    'wallet_number' => '010XXXXXXXX',
                    'account_name' => 'اسم صاحب المحفظة',
                    'instructions' => 'برجاء تحويل المبلغ على هذا الرقم، ثم إرفاق صورة (سكرين شوت) لرسالة تأكيد التحويل.',
                ],
            ],
            [
                'title_en' => 'Etisalat Cash',
                'title_ar' => 'اتصالات كاش',
                'title_fr' => 'Etisalat Cash',
                'title_de' => 'Etisalat Cash',
                'slug_en' => 'etisalat-cash',
                'slug_ar' => 'اتصالات-كاش',
                'slug_fr' => 'etisalat-cash',
                'slug_de' => 'etisalat-cash',
                'code' => 'wallet_etisalat',
                'status' => 0,
                'banner_en' => 'payment-methods/etisalat.png',
                'banner_ar' => 'payment-methods/etisalat.png',
                'banner_fr' => 'payment-methods/etisalat.png',
                'banner_de' => 'payment-methods/etisalat.png',
                'config' => [
                    'wallet_number' => '011XXXXXXXX',
                    'account_name' => 'اسم صاحب المحفظة',
                    'instructions' => 'برجاء تحويل المبلغ على هذا الرقم، ثم إرفاق صورة (سكرين شوت) لرسالة تأكيد التحويل.',
                ],
            ],
            [
                'title_en' => 'Orange Cash',
                'title_ar' => 'أورانج كاش',
                'title_fr' => 'Orange Cash',
                'title_de' => 'Orange Cash',
                'slug_en' => 'orange-cash',
                'slug_ar' => 'اورانج-كاش',
                'slug_fr' => 'orange-cash',
                'slug_de' => 'orange-cash',
                'code' => 'wallet_orange',
                'status' => 0,
                'banner_en' => 'payment-methods/orange.png',
                'banner_ar' => 'payment-methods/orange.png',
                'banner_fr' => 'payment-methods/orange.png',
                'banner_de' => 'payment-methods/orange.png',
                'config' => [
                    'wallet_number' => '012XXXXXXXX',
                    'account_name' => 'اسم صاحب المحفظة',
                    'instructions' => 'برجاء تحويل المبلغ على هذا الرقم، ثم إرفاق صورة (سكرين شوت) لرسالة تأكيد التحويل.',
                ],
            ],
            [
                'title_en' => 'WE Pay',
                'title_ar' => 'وي باي',
                'title_fr' => 'WE Pay',
                'title_de' => 'WE Pay',
                'slug_en' => 'we-pay',
                'slug_ar' => 'وي-باي',
                'slug_fr' => 'we-pay',
                'slug_de' => 'we-pay',
                'code' => 'wallet_we',
                'status' => 0,
                'banner_en' => 'payment-methods/we.png',
                'banner_ar' => 'payment-methods/we.png',
                'banner_fr' => 'payment-methods/we.png',
                'banner_de' => 'payment-methods/we.png',
                'config' => [
                    'wallet_number' => '015XXXXXXXX',
                    'account_name' => 'اسم صاحب المحفظة',
                    'instructions' => 'برجاء تحويل المبلغ على هذا الرقم، ثم إرفاق صورة (سكرين شوت) لرسالة تأكيد التحويل.',
                ],
            ],
            [
                'title_en' => 'InstaPay',
                'title_ar' => 'إنستا باي',
                'title_fr' => 'InstaPay',
                'title_de' => 'InstaPay',
                'slug_en' => 'instapay',
                'slug_ar' => 'انستا-باي',
                'slug_fr' => 'instapay',
                'slug_de' => 'instapay',
                'code' => 'instapay',
                'status' => 0,
                'banner_en' => 'payment-methods/instapay.png',
                'banner_ar' => 'payment-methods/instapay.png',
                'banner_fr' => 'payment-methods/instapay.png',
                'banner_de' => 'payment-methods/instapay.png',
                'config' => [
                    'instapay_address' => 'username@instapay',
                    'mobile_number' => '01XXXXXXXXX',
                    'account_name' => 'اسم الحساب',
                    'instructions' => 'برجاء التحويل على عنوان إنستا باي الموضح أو رقم الموبايل، وإرفاق إيصال التحويل.',
                ],
            ],
        ];

        try {
            PaymentMethod::query()->withTrashed()->forceDelete();
        } catch (\Exception $e) {
            PaymentMethod::query()->delete();
        }

        foreach ($methods as $method) {
            PaymentMethod::query()->create($method);
        }

        $this->command->info('Payment methods seeded successfully with FR and DE!');
    }
}
