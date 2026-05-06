<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    protected $fillable = [
        'item_id', 'user_id', 'reviewer_name', 'rating', 'comment', 'status', 'is_admin_created',
    ];

    public function item()
    {
        return $this->belongsTo(Item::class);
    }

    public function user()
    {
        return $this->belongsTo(ResidencyUser::class, 'user_id');
    }
}
