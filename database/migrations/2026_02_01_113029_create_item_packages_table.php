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
        Schema::create('item_packages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('item_id')->constrained('items')->cascadeOnDelete();
            $table->string('title_en')->nullable();
            $table->string('title_ar')->nullable();
            $table->string('title_fr')->nullable();
            $table->string('title_de')->nullable();
            $table->text('features_en')->nullable();
            $table->text('features_ar')->nullable();
            $table->text('features_fr')->nullable();
            $table->text('features_de')->nullable();
            $table->double('price', 15, 2)->default(0);
            $table->tinyInteger('status')->default(0);
            $table->string('attachment')->nullable();
            $table->timestamps();
        });

        Schema::table('order_items', function (Blueprint $table) {
            $table->unsignedBigInteger('item_package_id')->nullable()->after('item_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('item_packages');
    }
};
