<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class DiseaseType extends Model
{
    use softDeletes;
    protected $guarded = [];

    protected $connection = 'tenant';

    public function patientsEducation(): HasMany
    {
        return $this->hasMany(PatientEducation::class, 'disease_type_id');
    }

    public function residenciesProgram(): HasMany
    {
        return $this->hasMany(ResidencyProgram::class, 'disease_type_id');
    }

    public function getCreatedAtAttribute($value): string
    {
        return Carbon::parse($value)->format('l, d F Y - H:i A');
    }

    public function getUpdatedAtAttribute($value): string
    {
        return Carbon::parse($value)->format('l, d F Y - H:i A');
    }
}
