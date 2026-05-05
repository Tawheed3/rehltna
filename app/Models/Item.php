<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\MorphMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Item extends Model
{
    use softDeletes;

    protected $guarded = [];
    protected $connection = 'tenant';

    public function packages(): HasMany
    {
        return $this->hasMany(ItemPackage::class, 'item_id');
    }

    public function excludes(): HasMany
    {
        return $this->hasMany(ItemExclude::class, 'item_id');
    }

    public function prices(): HasMany
    {
        return $this->hasMany(ItemPrice::class, 'item_id');
    }

    public function routes(): HasMany
    {
        return $this->hasMany(ItemRoute::class, 'item_id');
    }

    public function itemType(): BelongsTo
    {
        return $this->belongsTo(ItemType::class, 'item_type_id');
    }

    public function galleries(): MorphMany
    {
        return $this->morphMany(Gallery::class, 'galleryable')->where('type', 'general');
    }

    public function privateGalleries(): MorphMany
    {
        return $this->morphMany(Gallery::class, 'galleryable')->where('type', 'private');
    }

    public function itineraries(): HasMany
    {
        return $this->hasMany(ItemItinerary::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function getResponsibleEmails(): array
    {
        $ids = $this->responsible_user_ids ?? [];

        // Backward compat: fall back to the single user_id if no array set yet
        if (empty($ids) && $this->user_id) {
            $ids = [$this->user_id];
        }

        if (empty($ids)) {
            return [];
        }

        return User::whereIn('id', $ids)->pluck('email')->toArray();
    }

    public function students(): BelongsToMany
    {
        return $this->belongsToMany(ResidencyUser::class, 'item_residency_users', 'item_id', 'residency_user_id')
            ->withPivot('id', 'attendees')
            ->withTimestamps();
    }

    protected $appends = ['coupons', 'price_after_discount', 'is_active_feature'];

    protected $hidden = ['assignedCoupons'];

    protected $casts = [
        'featured_at'          => 'datetime',
        'responsible_user_ids' => 'array',
    ];

    public function getPriceAfterDiscountAttribute()
    {
        $price = $this->price ?? 0;
        $discount = $this->discount ?? 0;

        if ($discount <= 0 || $this->is_active_feature == 0) {
            return $price;
        }

        if ($this->discount_type === 'percent') {
            $discountAmount = ($price * $discount) / 100;
            return max(0, $price - $discountAmount);
        }

        return max(0, $price - $discount);
    }

    public function getIsActiveFeatureAttribute(): int
    {
        if ($this->is_feature != 1 || !$this->featured_at) {
            return 0;
        }

        $featuredDate = Carbon::parse($this->featured_at);
        $daysPassed = $featuredDate->diffInDays(now());

        if ($daysPassed > 7) {
            $this->update(['is_feature' => 0, 'featured_at' => null]);
            return 0;
        }

        return 1;
    }

    public function assignedCoupons(): BelongsToMany
    {
        return $this->belongsToMany(Coupon::class, 'coupon_items');
    }

    public function getCouponsAttribute()
    {
        $validSpecificCoupons = $this->assignedCoupons->filter(function ($coupon) {
            $isActive = $coupon->status == 1;
            $isValidDate = $coupon->expires_at === null || $coupon->expires_at >= now();

            return $isActive && $isValidDate;
        });

        if ($validSpecificCoupons->isNotEmpty()) {
            return $validSpecificCoupons->values();
        }

        static $globalCoupons = null;
        if ($globalCoupons === null) {
            $globalCoupons = Coupon::query()
                ->doesntHave('items')
                ->where('status', 1)
                ->where(function ($q) {
                    $q->whereNull('expires_at')->orWhere('expires_at', '>=', now());
                })
                ->get();
        }
        return $globalCoupons;
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
