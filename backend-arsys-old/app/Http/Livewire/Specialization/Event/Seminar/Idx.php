<?php

namespace App\Http\Livewire\Specialization\Event\Seminar;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.specialization.event.seminar.idx');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}
