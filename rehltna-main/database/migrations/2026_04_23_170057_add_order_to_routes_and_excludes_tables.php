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
        Schema::table('item_routes', function (Blueprint $table) {
            $table->integer('order')->default(0)->after('icon');
        });

        Schema::table('item_excludes', function (Blueprint $table) {
            $table->integer('order')->default(0)->after('icon');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('item_routes', function (Blueprint $table) {
            $table->dropColumn('order');
        });

        Schema::table('item_excludes', function (Blueprint $table) {
            $table->dropColumn('order');
        });
    }
};
