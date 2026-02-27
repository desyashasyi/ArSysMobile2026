<?php

namespace App\Http\Livewire\Specialization\Research\LoginAs;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.specialization.research.login-as.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}
