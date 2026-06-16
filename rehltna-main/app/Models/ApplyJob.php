<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class ApplyJob extends Model
{
    use softDeletes;
    protected $guarded = [];
    protected $connection = 'tenant';
    public function career(): BelongsTo
    {
        return $this->belongsTo(Career::class);
    }
}
