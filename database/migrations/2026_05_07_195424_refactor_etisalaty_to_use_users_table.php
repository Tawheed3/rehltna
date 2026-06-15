<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Add etisalaty_role to users (null = no Etisalaty access)
        Schema::table('users', function (Blueprint $table) {
            $table->enum('etisalaty_role', ['employee', 'security'])->nullable()->after('role');
        });

        // 2. Drop old etisalaty_employee_contacts (FK pointed to etisalaty_users)
        Schema::dropIfExists('etisalaty_employee_contacts');

        // 3. Recreate with plain columns (no FK constraint due to InnoDB cross-db limitation)
        Schema::create('etisalaty_employee_contacts', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('employee_id');
            $table->unsignedBigInteger('contact_id');
            $table->timestamp('uploaded_at');
            $table->unique(['employee_id', 'contact_id']);
        });

        // 4. Drop the now-redundant etisalaty_users table
        Schema::dropIfExists('etisalaty_users');
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('etisalaty_role');
        });
    }
};
