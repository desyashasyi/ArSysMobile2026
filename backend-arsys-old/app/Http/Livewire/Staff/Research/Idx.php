<?php

namespace App\Http\Livewire\Staff\Research;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.staff.research.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
        /*if(is_null(Auth::user()->telegram_bypass)){
            if(is_null(Auth::user()->telegram)){
                return redirect()->route('arsys.telegram');
            }
        }
        */

    }
}
