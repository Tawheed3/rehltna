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
        Schema::table('tenants', function (Blueprint $table) {
            $table->text('options')->nullable()->default('home,social_integration,blogs,offers,ai_settings,sitemaps,items,jobs,contact,payment_methods,coupons,orders,subscribes,sliders,portfolios,custom_pages,testimonials,leads,settings,failed_jobs,events,events_galleries,news,members,disease_types,patients,residencies,protocols,clinical_publications')->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('tenants', function (Blueprint $table) {
            //
        });
    }
};
