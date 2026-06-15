<?php

namespace Database\Seeders;

use App\Models\Tenant;
use App\Models\TravelTool;
use Illuminate\Database\Seeder;

class TravelToolsSeeder extends Seeder
{
    public function run(): void
    {
        $tenant = Tenant::query()->first();
        if (!$tenant) {
            $this->command->warn('No tenant found. Skipping.');
            return;
        }
        $tenant->makeCurrent();
        $this->command->info("Seeding Travel Tools for tenant: {$tenant->name}");

        $tools = [
            ['icon' => '📶', 'title' => 'إنترنت أثناء السفر', 'description' => 'تجوال - شريحة دولية - باقة بيانات محلية. تأكد من تفعيل خدمة التجوال مع مزودك أو شراء شريحة محلية من المطار.', 'order' => 1],
            ['icon' => '🔌', 'title' => 'محول للشاحن', 'description' => 'تختلف منافذ الكهرباء من دولة لأخرى. احرص على اصطحاب محول عالمي يناسب الدولة التي ستسافر إليها.', 'order' => 2],
            ['icon' => '🔋', 'title' => 'باور بانك', 'description' => 'لا تنفد بطارية هاتفك في أثناء السياحة. احمل باور بانك بسعة كافية تضمن لك شحن جهازك أكثر من مرة.', 'order' => 3],
            ['icon' => '☂️', 'title' => 'شمسية للمطر', 'description' => 'إذا كانت وجهتك ذات مناخ ممطر احرص على اصطحاب شمسية خفيفة تُتحمل في الحقيبة اليدوية.', 'order' => 4],
            ['icon' => '🧥', 'title' => 'جاكيت للمطر', 'description' => 'جاكيت مقاوم للمطر خفيف الوزن يحميك من البرد والبلل ويسهل حمله في الحقيبة دون إشغال مساحة كبيرة.', 'order' => 5],
            ['icon' => '🚿', 'title' => 'شطاف مسافر', 'description' => 'شطاف محمول صغير الحجم ضروري للمسافر المسلم للحفاظ على الطهارة في أي مكان.', 'order' => 6],
            ['icon' => '⚖️', 'title' => 'ميزان للحقائب', 'description' => 'تجنب رسوم الوزن الزائد في المطار باصطحاب ميزان صغير للحقائب تستطيع من خلاله قياس وزن حقيبتك قبل التوجه للمطار.', 'order' => 7],
            ['icon' => '🕌', 'title' => 'سجادة للصلاة', 'description' => 'سجادة صلاة خفيفة قابلة للطي تضمن لك أداء صلواتك في أي مكان بكل راحة واطمئنان.', 'order' => 8],
            ['icon' => '✈️', 'title' => 'وسادة رقبة للطائرة', 'description' => 'في الرحلات الطويلة تُعد وسادة الرقبة القابلة للنفخ من أهم مستلزمات السفر للحفاظ على راحة رقبتك.', 'order' => 9],
            ['icon' => '💊', 'title' => 'أدويتك الخاصة', 'description' => 'لا تنسَ اصطحاب أدويتك المزمنة بكميات كافية تغطي فترة سفرك. احتفظ بها في حقيبتك اليدوية وليس في الحقيبة المسجَّلة.', 'order' => 10],
        ];

        foreach ($tools as $tool) {
            TravelTool::firstOrCreate(
                ['title' => $tool['title']],
                array_merge($tool, ['is_active' => true])
            );
        }
    }
}
