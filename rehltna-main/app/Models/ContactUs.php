<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ContactUs extends Model
{
    use softDeletes;
    protected $guarded = [];
    protected $connection = 'tenant';
}
