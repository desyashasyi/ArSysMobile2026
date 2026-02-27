<?php

namespace App\Http\Livewire\Student\Profile;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.student.profile.idx');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}
