<?php

namespace App\Http\Livewire\Staff;

use App\Models\ArSys\Staff;
use Auth;
use Jenssegers\Agent\Agent;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.staff.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }else{
            //dd(Auth::user()->sso);
            if(!is_null(Staff::where('code', Auth::user()->sso)->first())){
                Staff::where('code', Auth::user()->sso)->update([
                    'user_id' => Auth::user()->id,
                ]);
            }
            /*if(is_null(Auth::user()->telegram_bypass)){
                if(is_null(Auth::user()->telegram)){
                    return redirect()->route('arsys.telegram');
                }
            }
            */
            $agent = new Agent();
            if($agent->isPhone()){
                return redirect()->route('mobile.staff');
            }
        }

    }

}
