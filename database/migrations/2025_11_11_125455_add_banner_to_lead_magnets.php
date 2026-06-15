<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('lead_magnets', function (Blueprint $table) {
            $table->string('banner_en')->nullable();
            $table->string('banner_ar')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('lead_magnets', function (Blueprint $table) {
            $table->dropColumn(['banner_en', 'banner_ar']);
        });
    }
};
