<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ItemPrice extends Model
{
    protected $guarded = [];
    protected $connection = 'tenant';
}
