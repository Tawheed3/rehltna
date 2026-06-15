<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('etisalaty_users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');
            $table->enum('role', ['employee', 'security']);
            $table->timestamps();
        });

        Schema::create('etisalaty_contacts', function (Blueprint $table) {
            $table->id();
            $table->string('phone_number')->unique();
            $table->string('contact_name');
            $table->timestamp('first_seen_at');
            $table->timestamp('last_seen_at');
            $table->timestamps();
        });

        Schema::create('etisalaty_employee_contacts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('employee_id')->constrained('etisalaty_users')->cascadeOnDelete();
            $table->foreignId('contact_id')->constrained('etisalaty_contacts')->cascadeOnDelete();
            $table->timestamp('uploaded_at');
            $table->unique(['employee_id', 'contact_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('etisalaty_employee_contacts');
        Schema::dropIfExists('etisalaty_contacts');
        Schema::dropIfExists('etisalaty_users');
    }
};
