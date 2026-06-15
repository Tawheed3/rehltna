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
        Schema::table('residency_users', function (Blueprint $table) {
            $table->string('phone')->nullable();
            $table->string('specialty')->nullable();
            $table->string('country')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('residency_users', function (Blueprint $table) {
            $table->dropColumn(['phone', 'specialty', 'country']);
        });
    }
};
