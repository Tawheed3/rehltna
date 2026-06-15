<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'tenant';

    public function up(): void
    {
        Schema::connection('tenant')->table('items', function (Blueprint $table) {
            $table->json('responsible_user_ids')->nullable()->after('user_id');
        });
    }

    public function down(): void
    {
        Schema::connection('tenant')->table('items', function (Blueprint $table) {
            $table->dropColumn('responsible_user_ids');
        });
    }
};
