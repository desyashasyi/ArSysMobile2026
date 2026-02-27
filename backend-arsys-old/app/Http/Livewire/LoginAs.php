<?php

namespace App\Http\Livewire;

use Livewire\Component;

class LoginAs extends Component
{
    public function render()
    {
        return view('livewire.login-as')->layout('adminlte::page');
    }
}
