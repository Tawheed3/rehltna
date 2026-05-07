<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EtisalatyContact extends Model
{
    protected $table = 'etisalaty_contacts';

    protected $fillable = ['phone_number', 'contact_name', 'first_seen_at', 'last_seen_at'];

    public $timestamps = true;

    public function employeeLinks()
    {
        return $this->hasMany(EtisalatyEmployeeContact::class, 'contact_id');
    }
}
