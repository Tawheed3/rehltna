<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Drop any unique indexes on item_itineraries (excluding PRIMARY) that
        // would prevent the same city from appearing more than once in a trip.
        $indexes = collect(DB::select("SHOW INDEX FROM item_itineraries WHERE Non_unique = 0 AND Key_name != 'PRIMARY'"));

        $dropped = [];
        foreach ($indexes as $index) {
            if (in_array($index->Key_name, $dropped)) continue;
            DB::statement("ALTER TABLE item_itineraries DROP INDEX `{$index->Key_name}`");
            $dropped[] = $index->Key_name;
        }
    }

    public function down(): void
    {
        // Intentionally empty — uniqueness on repeated cities should never be enforced.
    }
};
