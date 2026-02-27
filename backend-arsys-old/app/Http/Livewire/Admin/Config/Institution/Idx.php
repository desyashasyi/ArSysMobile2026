<?php

namespace App\Http\Livewire\Admin\Config\Institution;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.admin.config.institution.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}
