<?php

namespace App\Http\Livewire;

use Auth;
use Livewire\Component;
use Session;

class Logout extends Component
{
    public function render()
    {
        return view('livewire.logout');
    }
    public function mount(){
        Auth::user()->logout;
        Session::flush();
        cas()->logout();
        return redirect('/');
    }
}
