<?php

namespace App\Http\Livewire\Auth\Email;

use Livewire\Component;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use App\Models\User;
class Page extends Component
{
    public $email;
    public $sso;
    use LivewireAlert;
    public function render()
    {
        return view('livewire.auth.email.page');
    }

    public function save(){
        $email = explode('@', $this->email);
        $domain = array_pop($email);
        if($domain == 'upi.edu'){
            $this->validate([
                'email' => "required|email",
                //'sso' => "required",
            ]);
            if(!is_null(User::where('sso', $this->sso)->first())){
                User::where('sso', $this->sso)->update([
                    'email' => $this->email,
                    //'google_id' => $this->googleId,
                ]);
            }
            return redirect('/');
        }else{
            $this->alert('warning', 'Please enter valid email',[
                'position' => 'top',
            ]);
        }
    }

    public function mount($userCode){
        $this->sso = $userCode;
    }
}
