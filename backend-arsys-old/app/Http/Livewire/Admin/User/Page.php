<?php

namespace App\Http\Livewire\Admin\User;

use App\Models\ArSys\Staff;
use App\Models\ArSys\Student;
use App\Models\Role;
use App\Models\User;
use Auth;
use Illuminate\Support\Str;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $enabledExpandView = [];
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $viewIndex = null;
    public $tempIndex = null;
    public $viewEnable = null;
    public $menu;
    public $pageNumber = null;
    public $addAccountEnable = false;
    public $viewAccountEnable = null;
    public $search;
    protected $listeners = ['addAccountEnable_AdminUserAccount', 'startUserAccount_AdminUserAccount',
                            'refreshAccountView_' => '$refresh',
                            'refreshUserView_ArSysAdminUserPage' => '$refresh'];
    public function render()
    {
        if($this->tempIndex != $this->viewIndex){
            $this->enabledExpandView[$this->viewIndex] = 1;
            $this->enabledExpandView[$this->tempIndex] = null;
            $this->tempIndex = $this->viewIndex;
        }
        //$users = User::paginate(10);
        $users = User::whereHas('student', function($query){
                $query->where('program_id', Auth::user()->sysrole->program_id);
                //$query->where('program_id', Auth::user()->staff->program_id);
            })
            ->orWhereHas('staff', function($query){
                $query->where('program_id', Auth::user()->sysrole->program_id);
                //$query->where('program_id', Auth::user()->staff->program_id);
            })
            ->orderBy('name', 'ASC')
            ->paginate(10);

        if($this->search != null){
            $users = User::
                whereHas('staff', function($query){
                    $query->where('program_id', Auth::user()->sysrole->program_id)
                    //$query->where('program_id', Auth::user()->staff->program_id)
                    ->where('code','like', '%'.$this->search.'%')
                    ->orwhere('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%');
                })
                ->orWhereHas('student', function($query){
                    $query->where('program_id', Auth::user()->sysrole->program_id)
                    //$query->where('program_id', Auth::user()->staff->program_id)
                    ->where('number','like', '%'.$this->search.'%')
                    ->orwhere('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%');
                })
                /*
                ->orWhereHas('sysrole', function($query){
                    $query->where('program_id', Auth::user()->sysrole->program_id)
                    //$query->where('program_id', Auth::user()->staff->program_id)
                        ->where('code','like', '%'.$this->search.'%');
                })
                */
                ->orderBy('name', 'ASC')
                ->paginate(10);
        }
        foreach($users as $index => $user){
            $this->enabledExpandView[$index] = null;
        }
        if($this->pageNumber != $users->currentPage()){

            $this->pageNumber = $users->currentPage();
            $this->tempIndex = $users->count()+1;
            $this->viewIndex = $users->count()+1;
        }
        return view('livewire.admin.user.page', ['users' => $users]);
    }

    public function mount(){
        $this->addAccountEnable = false;
        $this->viewEnable = false;
    }
    public function expandView($viewIndex, $accountId){
        $this->viewIndex = $viewIndex;
        $this->enabledExpandView[$this->viewIndex] = 1;
        $this->enabledExpandView[$this->tempIndex] = 0;
        $this->addAccountEnable = false;
        $this->emit('accountView_AdminUserAccount', ['accountId' => $accountId]);
    }

    public function addAccountEnable_AdminUserAccount(){
        if($this->addAccountEnable == false){
            $this->addAccountEnable = true;
            $this->enabledExpandView[$this->tempIndex] = 0;
        }else{
            $this->addAccountEnable = false;
        }
    }

    public function startUserAccount_AdminUserAccount(){
        $this->enabledExpandView[$this->tempIndex] = 0;
    }

    public function removeRole($roleId, $userId){
        $role = Role::where('id', $roleId)->first();
        $user = User::find($userId);
        $user->detachRole($role->name);
    }

    public function loginAs($userId){
         $user = User::where('id', $userId)->firstorfail();
        if(Str::length($user->sso) < 9){
            if(!is_null(Student::where('number',$user->sso)->first())){
                Student::where('number',$user->sso)->update([
                    'user_id' => $userId,
                ]);
                Auth::login($user);
                return redirect()->route('arsys.student');
            }
        }else{
            if(!is_null(Staff::where('sso', $user->sso)->first())){
                Staff::where('sso', $user->sso)->update([
                    'user_id' => $userId,
                ]);
                Auth::login($user);
                return redirect()->route('arsys.staff');
            }
        }


    }
}
