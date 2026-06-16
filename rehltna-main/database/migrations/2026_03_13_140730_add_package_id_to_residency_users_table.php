<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('residency_users', function (Blueprint $table) {
            $table->foreignId('package_id')->nullable()->constrained('packages')->nullOnDelete();
            $table->decimal('earned_points', 10, 2)->default(0)->after('package_id');
            $table->decimal('available_points', 10, 2)->default(0)->after('earned_points');
            $table->decimal('used_points', 10, 2)->default(0)->after('available_points');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('residency_users', function (Blueprint $table) {
            $table->dropForeign(['package_id']);
            $table->dropColumn('package_id');
            $table->dropColumn(['earned_points', 'available_points', 'used_points']);
        });
    }
};
