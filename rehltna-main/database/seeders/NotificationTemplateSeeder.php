<?php

namespace Database\Seeders;

use App\Models\NotificationTemplate;
use App\Models\Tenant;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class NotificationTemplateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $tenantId = Tenant::query()->first()->id;
        $tenant = Tenant::query()->findOrFail($tenantId);
        $tenant->makeCurrent();
        $tenantName = $tenant->name ?? 'Unknown';
        $this->command->info("Seeding Payment Methods for Tenant: {$tenant->id} ({$tenantName})");

        DB::table('notification_templates')->truncate();

        $templates = [
            [
                'title' => '🌟 New Trip Alert: {trip_name} is Here!',
                'body' => 'Exciting news! We just added {trip_name} to our catalog. Book your spot now before it sells out.',
            ],
            [
                'title' => '🔥 Special Offer on {trip_name}!',
                'body' => 'Don\'t miss out on this amazing deal! {trip_name} is now available at a discounted rate for a limited time.',
            ],
            [
                'title' => '⏳ Last Chance to Book {trip_name}!',
                'body' => 'Spots are filling up fast for {trip_name}. Secure your booking today and get ready for an unforgettable experience.',
            ],
            [
                'title' => '🎒 Ready for an adventure? Join {trip_name}!',
                'body' => 'Pack your bags! {trip_name} is exactly what you need for your next getaway. Discover the details inside.',
            ],
            [
                'title' => '🌟 رحلة جديدة في انتظارك: {trip_name}!',
                'body' => 'خبر سعيد! لقد أضفنا رحلة {trip_name} إلى قائمتنا. احجز مكانك الآن قبل نفاد التذاكر.',
            ],
            [
                'title' => '🔥 عرض خاص ومميز على رحلة {trip_name}!',
                'body' => 'لا تفوت هذه الفرصة الرائعة! رحلة {trip_name} متاحة الآن بسعر مخفض لفترة محدودة.',
            ],
            [
                'title' => '⏳ الفرصة الأخيرة للانضمام إلى {trip_name}!',
                'body' => 'الأماكن تقترب من النفاد في رحلة {trip_name}. احجز مقعدك اليوم واستعد لتجربة لا تُنسى.',
            ],
            [
                'title' => '🎒 هل أنت مستعد للمغامرة؟ انضم إلى {trip_name}!',
                'body' => 'جهز حقائبك! رحلة {trip_name} هي ما تحتاجه لإجازتك القادمة. اكتشف التفاصيل الآن واحجز مكانك.',
            ],
        ];

        foreach ($templates as $template) {
            NotificationTemplate::create($template);
        }
    }
}
