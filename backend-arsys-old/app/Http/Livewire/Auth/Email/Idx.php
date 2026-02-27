<?php

namespace App\Http\Livewire\Auth\Email;

use Livewire\Component;

class Idx extends Component
{
    public $userCode;
    public function render()
    {
        return view('livewire.auth.email.idx');
    }

    public function mount($userCode){
       $this->userCode = $userCode;
    }
}
