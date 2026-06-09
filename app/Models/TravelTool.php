<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TravelTool extends Model
{
    protected $guarded = [];
    protected $connection = 'tenant';
    protected $casts = ['is_active' => 'boolean'];
}
