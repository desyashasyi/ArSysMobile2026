<?php

namespace App\Http\Livewire\Auth;

use Livewire\Component;
use App\Models\User;
use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Auth;

class SsoGoogle extends Component
{
    public $email;
    public $sso;
    use LivewireAlert;
    public function render()
    {
        return view('livewire.auth.sso-google');
    }
    public function mount(){
        $userFromGoogle = Socialite::driver('google')->stateless()->user();
        if(preg_match('/^\w+@upi\.edu$/i', $userFromGoogle->getEmail()) > 0){
            $userFromDatabase = User::where('email', $userFromGoogle->getEmail())->first();
            if (!is_null($userFromDatabase)) {
                Auth::login($userFromDatabase);
                if(strlen(Auth::user()->sso) == 4 ){
                    return redirect()->route('arsys.admin');
                }elseif(strlen(Auth::user()->sso) > 7){
                    return redirect()->route('arsys.staff');
                }else{
                    return redirect()->route('arsys.student');
                }
            }
            else{
                return redirect('/');
            }
            /*else{
                return redirect()->route('arsys.auth.email',  ['googleEmail' => $userFromGoogle->getEmail(), 'googleId' => $userFromGoogle->getId()]);
            }*/
        }
        else{
            return redirect('/');
        }
    }
}
