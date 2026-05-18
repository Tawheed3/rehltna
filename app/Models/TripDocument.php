<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class TripDocument extends Model
{
    protected $guarded = [];

    protected $casts = [
        'details' => 'array',
    ];

    public function item(): BelongsTo
    {
        return $this->belongsTo(Item::class, 'item_id');
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(ResidencyUser::class, 'trip_document_residency_users', 'trip_document_id', 'residency_user_id')
                    ->withTimestamps();
    }
}
