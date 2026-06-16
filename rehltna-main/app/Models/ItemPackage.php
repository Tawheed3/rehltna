<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ItemPackage extends Model
{
    protected $guarded = [];

    protected $connection = 'tenant';

    public function item(): BelongsTo
    {
        return $this->belongsTo(Item::class);
    }

    public function getAttachmentAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }

}
