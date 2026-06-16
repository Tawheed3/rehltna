<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;

class Order extends Model
{

    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }

    public function coupon(): BelongsTo
    {
        return $this->belongsTo(Coupon::class);
    }

    public function paymentLink(): HasOne
    {
        return $this->hasOne(PaymentLink::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(ResidencyUser::class, 'residency_user_id');
    }

    public function getPaymentProofAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }

    //  $model->created_at_formatted
    public function getCreatedAtFormattedAttribute(): string
    {
        return $this->created_at ? $this->created_at->format('l, d F Y - H:i A') : '';
    }

    //  $model->updated_at_formatted
    public function getUpdatedAtFormattedAttribute(): string
    {
        return $this->updated_at ? $this->updated_at->format('l, d F Y - H:i A') : '';
    }

}
