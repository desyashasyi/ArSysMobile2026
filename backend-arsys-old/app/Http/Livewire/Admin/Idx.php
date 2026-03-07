<?php

namespace App\Http\Livewire\Admin;

use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.admin.idx')->layout('adminlte::page');
    }
}
