<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class ResidencyUser extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, softDeletes;

    protected $guarded = [];

    protected $connection = 'tenant';

    protected $hidden = [
        'password',
        'remember_token',
    ];

    public function package(): BelongsTo
    {
        return $this->belongsTo(Package::class, 'package_id');
    }

    protected static function boot(): void
    {
        parent::boot();

        static::creating(function ($user) {
            if (empty($user->package_id)) {
                $silverPackage = Package::where('name_en', 'Silver')->first();
                if ($silverPackage) {
                    $user->package_id = $silverPackage->id;
                }
            }
        });
    }

    public function items(): BelongsToMany
    {
        return $this->belongsToMany(Item::class, 'item_residency_users', 'residency_user_id', 'item_id')
            ->withPivot('id', 'attendees', 'item_package_id')
            ->withTimestamps();
    }

    public function orders(): HasMany
    {
        return $this->hasMany(Order::class, 'residency_user_id');
    }

    public function pointLogs(): HasMany
    {
        return $this->hasMany(PointLog::class, 'residency_user_id');
    }

    public function tripDocuments(): BelongsToMany
    {
        return $this->belongsToMany(TripDocument::class, 'trip_document_residency_users', 'residency_user_id', 'trip_document_id')
                    ->withTimestamps();
    }

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
