<?php

namespace App\Http\Livewire\Components\Dropdown;

use App\Models\ArSys\StaffProgramPivot;
use Livewire\Component;

class Staff extends Component
{
    public $staffs;
    public function render()
    {
        return view('livewire.components.dropdown.staff');
    }
    public function mount($program){
        if(!is_null($program)){
            $this->staffs = StaffProgramPivot::where('program_id', $program)->get();
        }else{
            $this->staffs = collect();
        }

    }
}
