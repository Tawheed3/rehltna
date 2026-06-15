<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Setting extends Model
{
    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';

    protected $arrayKeys = [
        'facebook',
        'instagram',
        'twitter',
        'whatsapp',
        'tiktok',
        'snapchat',
        'site_address_en',
        'site_address_ar'
    ];

    public function getValueAttribute($value)
    {
        if (in_array($this->key, $this->arrayKeys) && is_string($value)) {
            return json_decode($value, true) ?? [];
        }
        return $value;
    }

}
