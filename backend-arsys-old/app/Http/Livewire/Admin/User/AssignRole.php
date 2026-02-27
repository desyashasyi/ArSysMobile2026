<?php

namespace App\Http\Livewire\Admin\User;

use App\Models\ArSys\Role;
use App\Models\User;
use Livewire\Component;

class AssignRole extends Component
{
    protected $listeners = ['setUserRole_ArSysAdminUserPage'];
    public $roles = null;
    public $user = null;
    public $userId = null;
    public function render()
    {
        if($this->userId){
            $this->roles = Role::where('name', '!=' ,'student')->get();
            $this->user = User::find($this->userId);
        }
        return view('livewire.admin.user.assign-role');
    }

    public function setUserRole_ArSysAdminUserPage($userId){
        if(strlen(User::find($userId)->sso) > 7){
            $this->userId = $userId;
            $this->emit('setUserRoleModal_ArSysAdminUserPage');
        }else{
            User::find($userId)->assignRole('student');
            $this->emitUp('refreshUserView_ArSysAdminUserPage');
        }

    }

    public function removeRole($roleId){
        $role = Role::where('id', $roleId)->first();
        $user = User::find($this->userId);
        $user->removeRole($role->name);
    }

    public function assignRole($roleId){
        User::find($this->userId)->assignRole(Role::find($roleId)->name);
    }

    public function close(){
        $this->emitUp('refreshUserView_ArSysAdminUserPage');
    }
}
