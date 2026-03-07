<?php

namespace App\Http\Livewire;

use App\Models\User;
use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render(){
        return view('livewire.idx');
    }

    public function mount(){
        Auth::login(User::where('name', 'Guest')->first());
    }
}
