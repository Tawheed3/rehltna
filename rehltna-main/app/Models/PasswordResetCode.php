<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PasswordResetCode extends Model
{
    use softDeletes;
    public $timestamps = false;
    protected $guarded = [];

    protected $connection = 'tenant';
}
