<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\Tenant;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::query()->updateOrCreate([
            'email' => 'admin@rehltna-panel.com',
        ], [
            'name' => 'Admin Rehltna Panel',
            'password' => Hash::make('rehltna$2026@panel'),
            'email_verified_at' => now(),
            'role' => 'admin',
            'role_id' => Role::query()->where('name', 'Admin')->first()->id,
            'tenant_id' => Tenant::query()->first()->id,
        ]);
    }
}
