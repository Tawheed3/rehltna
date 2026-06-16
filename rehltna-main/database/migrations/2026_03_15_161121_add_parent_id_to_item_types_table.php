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
        Schema::table('item_types', function (Blueprint $table) {
            $table->foreignId('parent_id')->nullable()->constrained('item_types')->nullOnDelete();
            $table->string('whatsapp')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('item_types', function (Blueprint $table) {
            $table->dropForeign('item_types_parent_id_foreign');
            $table->dropColumn(['parent_id', 'whatsapp']);
        });
    }
};
