<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::dropIfExists('trip_document_users');

        Schema::create('trip_document_residency_users', function (Blueprint $table) {
            $table->id();
            $table->foreignId('trip_document_id')->constrained('trip_documents')->onDelete('cascade');
            $table->foreignId('residency_user_id')->constrained('residency_users')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['trip_document_id', 'residency_user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('trip_document_residency_users');

        Schema::create('trip_document_users', function (Blueprint $table) {
            $table->id();
            $table->foreignId('trip_document_id')->constrained('trip_documents')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->timestamps();

            $table->unique(['trip_document_id', 'user_id']);
        });
    }
};
