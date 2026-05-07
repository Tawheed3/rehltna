<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Gallery extends Model
{
    protected $guarded = [];

    protected $connection = 'tenant';
    public function galleryable(): MorphTo
    {
        return $this->morphTo();
    }
    public function getImageAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }

    protected $hidden = [
        'created_at',
        'updated_at',
        'id',
        'galleryable_type',
        'galleryable_id',
        'type',
    ];

}
