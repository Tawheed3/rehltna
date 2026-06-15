<?php

namespace Database\Seeders;

use App\Models\Package;
use App\Models\ResidencyUser;
use App\Models\Tenant;
use Illuminate\Database\Seeder;

class PackageSeeder extends Seeder
{
    public function run(): void
    {
        $tenantId = Tenant::query()->first()->id;
        $tenant = Tenant::query()->findOrFail($tenantId);
        $tenant->makeCurrent();
        $tenantName = $tenant->name ?? 'Unknown';
        $this->command->info("Seeding Packages for Tenant: {$tenant->id} ({$tenantName})");

        $packages = [
            [
                'name_en' => 'Silver',
                'name_ar' => 'الفضية',
                'price' => 0.00,
                'points_multiplier' => 1.00,
                'icon' => 'fas fa-medal',
                'features' => [
                    ['en' => 'Basic Support', 'ar' => 'دعم فني أساسي'],
                    ['en' => 'Standard Points', 'ar' => 'نقاط قياسية'],
                ],
            ],
            [
                'name_en' => 'Gold',
                'name_ar' => 'الذهبية',
                'price' => 100.00,
                'points_multiplier' => 1.50,
                'icon' => 'fas fa-crown',
                'features' => [
                    ['en' => 'Priority Support', 'ar' => 'دعم فني بأولوية'],
                    ['en' => '1.5x Points Multiplier', 'ar' => 'مضاعفة النقاط 1.5x'],
                ],
            ],
            [
                'name_en' => 'Platinum',
                'name_ar' => 'البلاتينية',
                'price' => 250.00,
                'points_multiplier' => 2.00,
                'icon' => 'fas fa-gem',
                'features' => [
                    ['en' => '24/7 VIP Support', 'ar' => 'دعم VIP على مدار الساعة'],
                    ['en' => '2x Points Multiplier', 'ar' => 'مضاعفة النقاط 2x'],
                ],
            ],
            [
                'name_en' => 'Diamond',
                'name_ar' => 'الماسية',
                'price' => 500.00,
                'points_multiplier' => 3.00,
                'icon' => 'fas fa-trophy',
                'features' => [
                    ['en' => 'Dedicated Account Manager', 'ar' => 'مدير حساب مخصص'],
                    ['en' => '3x Points Multiplier', 'ar' => 'مضاعفة النقاط 3x'],
                ],
            ],
        ];
        try {
            Package::query()->withTrashed()->forceDelete();
        } catch (\Exception $e) {
            Package::query()->delete();
        }

        foreach ($packages as $pkg) {
            Package::updateOrCreate(
                ['name_en' => $pkg['name_en']],
                $pkg
            );
        }

        $silverPackage = Package::query()->where('name_en', 'Silver')->first();

        if ($silverPackage) {
            $updatedUsersCount = ResidencyUser::query()
                ->whereNull('package_id')
                ->update(['package_id' => $silverPackage->id]);
            $this->command->info("Assigned Silver package to {$updatedUsersCount} users.");
        }
    }
}
