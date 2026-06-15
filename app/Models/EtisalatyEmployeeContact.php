<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EtisalatyEmployeeContact extends Model
{
    protected $table = 'etisalaty_employee_contacts';

    protected $fillable = ['employee_id', 'contact_id', 'uploaded_at'];

    public $timestamps = false;

    public function employee()
    {
        return $this->belongsTo(User::class, 'employee_id');
    }

    public function contact()
    {
        return $this->belongsTo(EtisalatyContact::class, 'contact_id');
    }
}
