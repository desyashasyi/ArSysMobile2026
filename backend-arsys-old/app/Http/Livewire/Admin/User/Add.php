<?php

namespace App\Http\Livewire\Admin\User;

use App\Models\Role;
use App\Models\User;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Add extends Component
{
    use LivewireAlert;
    public $roles;
    public $userRoles = [];
    public $username, $sso, $email, $role;
    public function render()
    {
        return view('livewire.admin.user.add');
    }

    public function mount(){
        $this->roles = Role::all();
        $this->clearForm();
    }

    public function hydrate(){
        $this->emit('reloadSelectStudentSupervisor');
    }

    public function clearForm(){

    }

    protected $rules = [
        'username' => 'required',
        'sso' => 'required|min:7|max:15',
        'email' => 'required',
        'roles' => 'required|array',
    ];
    protected $messages = [
            'program.required' => 'The Program of Study is required',
            'email.required' => 'The Email Address cannot be empty.',
    ];
    public function save(){
        //dd($this->userRoles);
        $this->validate();
        if(is_null(User::where('sso', $this->sso)->where('email', $this->email)
            ->where('name', $this->username)->first())){
                User::create([
                    'name' => $this->username,
                    'sso' => $this->sso,
                    'email' => $this->email,
                ]);
                $user = User::where('sso', $this->sso)->where('email', $this->email)
                ->where('name', $this->username)->first();
                //dd($this->userRoles);
                if(!is_null($user)){
                    foreach($this->userRoles as $role){
                        $user->assignRole(Role::where('id', $role)->first()->name);
                    }
                }
                $this->alert('success', 'The new account has been recorded');
                $this->clearForm();
                $this->emitUp('refreshAccountView');
        }else{
            $this->alert('danger', 'There is a duplicate entry');
        }



    }

    public function addRole(){
        dd('addRole');
    }
}
