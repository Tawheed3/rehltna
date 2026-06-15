<?php

namespace Database\Seeders;

use App\Models\Tenant;
use Illuminate\Database\Seeder;
use App\Models\Role;

class AdminRoleSeeder extends Seeder
{
    public function run(): void
    {
        $tenantId = Tenant::query()->first()->id;
        $tenant = Tenant::query()->findOrFail($tenantId);
        $tenant->makeCurrent();
        $tenantName = $tenant->name ?? 'Unknown';
        $this->command->info("Seeding Payment Methods for Tenant: {$tenant->id} ({$tenantName})");

        $allPermissions = [
            'manage_blogs',
            'manage_trips',
            'manage_locations',
            'manage_customers',
            'manage_notifications',
            'manage_payments',
            'manage_website',
            'manage_settings',
            'manage_staff',
        ];

        Role::updateOrCreate(
            ['name' => 'Admin'],
            ['permissions' => $allPermissions]
        );
    }
}
