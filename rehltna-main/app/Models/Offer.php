<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Offer extends Model
{
    use softDeletes;
    protected $guarded = [];
    protected $connection = 'tenant';
    public function offerType(): BelongsTo
    {
        return $this->belongsTo(TypeOffer::class,'type_offer_id');
    }
    public function getBannerEnAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }
    public function getBannerArAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }

    public function getMetaImgAttribute($value): null|string
    {
        return $value ? asset($value) : null;
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
