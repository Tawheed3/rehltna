<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Delete employee_contact rows whose contact was already deleted
        DB::statement('
            DELETE FROM etisalaty_employee_contacts
            WHERE contact_id NOT IN (SELECT id FROM etisalaty_contacts)
        ');
    }

    public function down(): void {}
};
