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
        Schema::create('payment_methods', function (Blueprint $table) {
            $table->id();
            $table->string('title_en')->nullable();
            $table->string('title_ar')->nullable();
            $table->string('slug_en')->unique()->nullable();
            $table->string('slug_ar')->unique()->nullable();
            $table->text('banner_en')->nullable();
            $table->text('banner_ar')->nullable();
            $table->string('code')->unique(); // cash, stripe, paypal, valu, fatora, wallet
            $table->tinyInteger('status')->default(0);
            $table->json('config')->nullable(); // API keys, secrets
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payment_methods');
    }
};
