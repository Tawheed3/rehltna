<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Coupon extends Model
{
    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';

    public function items(): BelongsToMany
    {
        return $this->belongsToMany(Item::class, 'coupon_items');
    }

    public function isValid(): bool
    {
        if (!$this->status) return false;
        if ($this->expires_at && $this->expires_at < now()) return false;
        if ($this->usage_limit && $this->orders()->count() >= $this->usage_limit) return false;
        return true;
    }

    public function orders(): HasMany
    {
        return $this->hasMany(Order::class);
    }

}
