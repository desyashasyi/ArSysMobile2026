<?php

namespace App\Http\Livewire;

use Auth;
use Livewire\Component;

class IdxAdmin extends Component
{
    public function render()
    {
        return view('livewire.idx-admin')->layout('adminlte::page');
    }
    public function mount(){
        dd(Auth::user()->roles);
    }
}
