<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PaymentLink extends Model
{
    use softDeletes;
    protected $guarded = [];
    protected $connection = 'tenant';
    protected $casts = [
        'items' => 'array',
    ];
}
