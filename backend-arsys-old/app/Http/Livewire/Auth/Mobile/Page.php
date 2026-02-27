<?php

namespace App\Http\Livewire\Auth\Mobile;

use Livewire\Component;
use Auth;
use App\Models\User;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Illuminate\Support\Facades\Hash;
class Page extends Component
{
    public $email;
    public $password;
    public $retypePassword;
    use LivewireAlert;
    public function render()
    {
        $this->email = Auth::user()->email;
        return view('livewire.auth.mobile.page');
    }

    public function mount(){
        $this->password = Auth::user()->password;
        $this->retypePassword = Auth::user()->password;
    }
    public function save(){
        $this->validate([
            'password' => 'required',
            'retypePassword' => 'required',
        ]);

        if($this->password == $this->retypePassword){
            User::where('id', Auth::user()->id)->update([
                'password' => Hash::make($this->password),
            ]);
            $this->alert('success', 'Your password has been saved',[
                'position' => 'top-center',
            ]);
        }else{
            $this->alert('warning', 'Entered password does not match',[
                'position' => 'top-center',
            ]);
        }
        
    }

    public function clear(){
        $this->password = null;
        $this->retypePassword  = null;
    }
}
