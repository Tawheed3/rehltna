<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CustomPage extends Model
{
    use softDeletes;
    protected $guarded = [];
    protected $connection = 'tenant';

    public function getMetaImgAttribute($value): null|string
    {
        return $value ? asset($value) : null;
    }
}
