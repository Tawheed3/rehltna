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
        Schema::disableForeignKeyConstraints();

        try {
            Schema::table('item_residency_users', function (Blueprint $table) {
                $table->dropForeign(['residency_user_id']);
            });
        } catch (\Throwable $e) {}

        try {
            Schema::table('item_residency_users', function (Blueprint $table) {
                $table->dropForeign(['item_id']);
            });
        } catch (\Throwable $e) {}

        try {
            Schema::table('item_residency_users', function (Blueprint $table) {
                $table->dropUnique(['residency_user_id', 'item_id']);
            });
        } catch (\Throwable $e) {}

        Schema::table('item_residency_users', function (Blueprint $table) {
            $table->foreignId('item_package_id')->nullable()->after('item_id')
                ->constrained('item_packages')->nullOnDelete();

            $table->foreign('residency_user_id')->references('id')->on('residency_users')->onDelete('cascade');
            $table->foreign('item_id')->references('id')->on('items')->onDelete('cascade');

            $table->unique(['residency_user_id', 'item_id', 'item_package_id'], 'user_course_pkg_unique');
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::disableForeignKeyConstraints();

        try {
            Schema::table('item_residency_users', function (Blueprint $table) {
                $table->dropUnique('user_course_pkg_unique');
            });
        } catch (\Throwable $e) {}

        try {
            Schema::table('item_residency_users', function (Blueprint $table) {
                $table->dropForeign(['item_package_id']);
                $table->dropColumn('item_package_id');
            });
        } catch (\Throwable $e) {}

        Schema::table('item_residency_users', function (Blueprint $table) {
            $table->unique(['residency_user_id', 'item_id']);
        });

        Schema::enableForeignKeyConstraints();
    }
};
