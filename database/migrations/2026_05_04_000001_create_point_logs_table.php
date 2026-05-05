<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'tenant';

    public function up(): void
    {
        Schema::connection('tenant')->create('point_logs', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('residency_user_id');
            $table->enum('type', ['trip_earned', 'employee_adjusted', 'trip_used']);
            $table->integer('points');
            $table->integer('balance_before');
            $table->integer('balance_after');
            $table->string('reason')->nullable();
            $table->unsignedBigInteger('order_id')->nullable();
            $table->string('trip_name')->nullable();
            $table->unsignedBigInteger('employee_id')->nullable();
            $table->string('employee_name')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::connection('tenant')->dropIfExists('point_logs');
    }
};
