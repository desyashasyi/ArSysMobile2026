<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use App\Models\ArSys\Student;
use App\Models\ArSys\Staff;
use App\Models\ArSys\TelegramId;
use App\Models\ArSys\InstitutionRole;
class User extends Authenticatable
{
    use HasRoles;
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'sso',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function adminlte_profile_url()
    {
        return 'usprovie';
    }

    public function student(){
        return $this->hasOne(Student::class, 'user_id', 'id');
    }

    public function staff(){
        return $this->hasOne(Staff::class, 'user_id', 'id');
    }
    public function sysrole(){
        return $this->hasOne(InstitutionRole::class, 'user_id', 'id');
    }

    public function telegram(){
        return $this->hasOne(TelegramId::class, 'user_id', 'id');
    }
}
