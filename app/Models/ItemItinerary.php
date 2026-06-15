<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ItemItinerary extends Model
{
    protected $guarded = [];

    protected $connection = 'tenant';

    public function city(): BelongsTo
    {
        return $this->belongsTo(City::class, 'city_id');
    }

    public function places()
    {
        return $this->hasMany(ItemItineraryPlace::class, 'itinerary_id');
    }
}
