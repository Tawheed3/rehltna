<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class EtisalatyUser extends Authenticatable
{
    use HasApiTokens;

    protected $table = 'etisalaty_users';

    protected $fillable = ['name', 'email', 'password', 'role'];

    protected $hidden = ['password'];

    public function employeeContacts()
    {
        return $this->hasMany(EtisalatyEmployeeContact::class, 'employee_id');
    }
}
