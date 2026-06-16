<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class LeadMagnet extends Model
{

    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';


    public function type(): BelongsTo
    {
        return $this->belongsTo(LeadMagnetType::class, 'lead_magnet_type_id');
    }

    public function leads(): HasMany
    {
        return $this->hasMany(Lead::class);
    }

    public function getBannerEnAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }


    public function getBannerArAttribute($value): null|string
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
