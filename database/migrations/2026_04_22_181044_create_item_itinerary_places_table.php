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
        Schema::create('item_itinerary_places', function (Blueprint $table) {
            $table->id();
            $table->foreignId('itinerary_id')->constrained('item_itineraries')->cascadeOnDelete();
            $table->string('title_en')->nullable();
            $table->string('title_ar')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('item_itinerary_places');
    }
};
