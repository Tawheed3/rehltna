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
        Schema::table('items', function (Blueprint $table) {
            $table->decimal('discount', 10, 2)->default(0)->after('price');
            $table->enum('discount_type', ['amount', 'percent'])->default('amount')->after('discount');
            $table->boolean('out_of_stock')->default(0)->after('status');
            $table->timestamp('featured_at')->nullable()->after('is_feature');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('items', function (Blueprint $table) {
            $table->dropColumn(['discount', 'discount_type', 'out_of_stock', 'featured_at']);
        });
    }
};
