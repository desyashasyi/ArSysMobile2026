<?php

namespace App\Http\Livewire\Auth;

use Livewire\Component;
use App\Models\User;
use Auth;
class SsoUpi extends Component
{
    public function render()
    {
        return view('livewire.auth.sso-upi');
    }

    public function mount()
    {
        //$userCode = '197608272009121001';
        //Fixed
        $userCode = cas()->user();
        if (is_null(User::where('sso', $userCode)->first())){
            if (strlen($userCode) > 7){
                $user = User::create([
                    'sso' => $userCode,
                ]);
                $user->assignRole('staff');

                if(!is_null($user->staff)){
                    User::where('sso', $userCode)->update([
                        'name' => $user->staff->code,
                    ]);

                    Staff::where('sso', $userCode)->update([
                        'user_id' => $user->id,
                    ]);
                }
            }else{

                $user = User::create([
                    'name' => 's'.$userCode,
                    'sso' => $userCode,
                ]);
                $user->assignRole('student');
            }
        }

        $user = User::where('sso', $userCode)->first();


        if(($user->email == null || $user->email == "")){
            return redirect()->route('arsys.auth.email',['userCode' => $userCode]);
        }

        Auth::login($user);
        if(strlen(Auth::user()->sso) == 4 ){
            return redirect()->route('arsys.admin');
        }elseif(strlen(Auth::user()->sso) > 7){
            return redirect()->route('arsys.staff');
        }else{
            return redirect()->route('arsys.student');
        }

    }
}
