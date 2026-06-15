<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class ItemType extends Model
{
    use softDeletes;

    protected $guarded = [];

    protected $connection = 'tenant';

    public function items(): HasMany
    {
        return $this->hasMany(Item::class);
    }

    public function parent(): BelongsTo
    {
        return $this->belongsTo(ItemType::class, 'parent_id');
    }

    public function allItems()
    {
        $childrenIds = $this->children()->pluck('id')->toArray();
        $allIds = array_merge([$this->id], $childrenIds);
        return Item::whereIn('item_type_id', $allIds);
    }

    protected $appends = ['total_items_recursive'];

    public function getTotalItemsRecursiveAttribute()
    {
        return $this->items_count + $this->children->sum('items_count');
    }

    public function children(): HasMany
    {
        return $this->hasMany(ItemType::class, 'parent_id');
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
