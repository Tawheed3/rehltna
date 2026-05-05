<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PointLog extends Model
{
    protected $guarded = [];

    protected $connection = 'tenant';

    public function user(): BelongsTo
    {
        return $this->belongsTo(ResidencyUser::class, 'residency_user_id');
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class, 'order_id');
    }
}
