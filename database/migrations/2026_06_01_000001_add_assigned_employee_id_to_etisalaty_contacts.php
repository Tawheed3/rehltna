<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('etisalaty_contacts', function (Blueprint $table) {
            // Plain column: Etisalaty tables may be used across tenant databases.
            $table->unsignedBigInteger('assigned_employee_id')->nullable()->after('contact_name')->index();
        });
    }

    public function down(): void
    {
        Schema::table('etisalaty_contacts', function (Blueprint $table) {
            $table->dropColumn('assigned_employee_id');
        });
    }
};
