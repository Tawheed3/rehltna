<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class RegisterUsers extends Model
{
    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';

    public function item(): BelongsTo
    {
        return $this->belongsTo(Item::class);
    }
    public function getCreatedAtAttribute($value): string
    {
        return Carbon::parse($value)->format('l, d F Y - H:i A');
    }

    public function getUpdatedAtAttribute($value): string
    {
        return Carbon::parse($value)->format('l, d F Y - H:i A');
    }
}
