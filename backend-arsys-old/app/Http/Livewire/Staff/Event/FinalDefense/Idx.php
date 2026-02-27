<?php

namespace App\Http\Livewire\Staff\Event\FinalDefense;

use Livewire\Component;
use Auth;
class Idx extends Component
{
    public function render()
    {
        return view('livewire.staff.event.final-defense.idx');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}
