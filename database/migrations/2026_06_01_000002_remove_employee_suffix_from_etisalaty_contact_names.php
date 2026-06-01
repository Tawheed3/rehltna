<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('etisalaty_contacts')
            ->where('contact_name', 'regexp', ' \\([^()]+@[^()]+\\)$')
            ->update([
                'contact_name' => DB::raw("REGEXP_REPLACE(contact_name, ' \\\\([^()]+@[^()]+\\\\)$', '')"),
            ]);
    }

    public function down(): void
    {
        // The removed display suffix cannot be reconstructed reliably.
    }
};
