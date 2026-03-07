<?php

namespace App\Http\Livewire\Components\Dropdown;


use Livewire\Component;


class Program extends Component
{
    public $listeners = ['selectProgram'];
    public $program;
    public function render()
    {
        $programs = Program::all();
        return view('livewire.components.dropdown.program', ['programs' => $programs]);
    }

    public function selectProgram(){
        $this->emitUp('selectProgram',['program' => $this->program]);
    }
}


