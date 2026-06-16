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
        Schema::table('items', function (Blueprint $table) {
            $table->string('season')->nullable();
            $table->string('whatsapp')->nullable();
            $table->string('quick_contact')->nullable();
            $table->string('contact_us')->nullable();
            $table->integer('earned_points')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->dropColumn(['season', 'whatsapp', 'quick_contact', 'contact_us', 'earned_points']);
        });
    }
};
