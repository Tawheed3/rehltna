<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $tables = [
        'users',
        'password_reset_codes',
        'orders',
        'ais',
        'settings',
        'testimonials',
        'order_items',
        'payment_links',
        'residency_users',
        'galleries',
        'tenants',
        'subscribes',
        'apply_jobs',
        'site_maps',
        'coupons',
        'register_users',
        'contact_us',
        'items',
        'categories',
        'type_offers',
        'blogs',
        'offers',
        'item_types',
        'sliders',
        'career_types',
        'careers',
        'events',
        'event_galleries',
        'members',
        'news',
        'portfolios',
        'error_uploadeds',
        'clinical_publications',
        'disease_types',
        'residency_programs',
        'patient_education',
        'portfolio_categories',
        'lead_magnet_types',
        'lead_magnets',
        'payment_methods',
        'custom_pages',
        'leads'
    ];

    protected $columnTypes = [
        'name'              => 'string',
        'title'             => 'string',
        'slug'              => 'string',
        'banner'            => 'string',
        'meta_title'        => 'string',
        'short_description' => 'text',
        'meta_description'  => 'text',
        'meta_keywords'     => 'text',
        'description'       => 'longText',
        'content'           => 'longText',
    ];

    public function up(): void
    {
        $newLocales = ['fr', 'de'];
        foreach ($this->tables as $tableName) {
            if (!Schema::hasTable($tableName)) {
                continue;
            }

            Schema::table($tableName, function (Blueprint $table) use ($tableName, $newLocales) {
                foreach ($this->columnTypes as $baseName => $type) {
                    if (Schema::hasColumn($tableName, $baseName . '_en')) {
                        foreach ($newLocales as $locale) {
                            $newColumn = $baseName . '_' . $locale;
                            if (!Schema::hasColumn($tableName, $newColumn)) {
                                if ($type === 'string') {
                                    $table->string($newColumn)->nullable()->after($baseName . '_en');
                                } elseif ($type === 'text') {
                                    $table->text($newColumn)->nullable()->after($baseName . '_en');
                                } elseif ($type === 'longText') {
                                    $table->longText($newColumn)->nullable()->after($baseName . '_en');
                                }
                            }
                        }
                    }
                }
                if (!Schema::hasColumn($tableName, 'deleted_at')) {
                    $table->softDeletes();
                }
            });
        }
    }

    public function down(): void
    {
        $newLocales = ['fr', 'de'];
        foreach ($this->tables as $tableName) {
            if (!Schema::hasTable($tableName)) continue;
            Schema::table($tableName, function (Blueprint $table) use ($tableName, $newLocales) {
                $columnsDrop = [];
                foreach ($this->columnTypes as $baseName => $type) {
                    foreach ($newLocales as $locale) {
                        $colName = $baseName . '_' . $locale;
                        if (Schema::hasColumn($tableName, $colName)) {
                            $columnsDrop[] = $colName;
                        }
                    }
                }

                if (!empty($columnsDrop)) {
                    $table->dropColumn($columnsDrop);
                }

                if (Schema::hasColumn($tableName, 'deleted_at')) {
                    $table->dropSoftDeletes();
                }
            });
        }
    }
};
