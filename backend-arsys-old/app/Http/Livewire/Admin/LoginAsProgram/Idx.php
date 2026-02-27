<?php

namespace App\Http\Livewire\Admin\LoginAsProgram;

use App\Models\ArSys\InstitutionRole;
use App\Models\User;
use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.admin.login-as-program.idx');
    }

    public function mount(){
        $programCode = Auth::user()->sysrole->program->code;
        if(User::find(InstitutionRole::where('code',$programCode)->first()->user_id)){
            Auth::login(User::find(InstitutionRole::where('code',$programCode)->first()->user_id));
            return redirect()->route('arsys.program');
        }

    }
}
