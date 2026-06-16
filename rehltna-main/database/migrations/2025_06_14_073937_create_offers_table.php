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
        Schema::create('offers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('type_offer_id')->constrained('type_offers')->onDelete('cascade');
            $table->text('title_en')->nullable();
            $table->text('title_ar')->nullable();
            $table->string('banner_en')->nullable();
            $table->string('banner_ar')->nullable();
            $table->decimal('price', 10, 2)->default(0);
            $table->tinyInteger('status')->default(0);
            $table->string('meta_title_ar')->nullable();
            $table->string('meta_title_en')->nullable();
            $table->text('meta_img')->nullable();
            $table->text('meta_description_ar')->nullable();
            $table->text('meta_description_en')->nullable();
            $table->text('meta_keywords_ar')->nullable();
            $table->text('meta_keywords_en')->nullable();
            $table->string('slug_en')->nullable();
            $table->string('slug_ar')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('offers');
    }
};
