<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Models\ArSys\Staff;
use Auth;
use Livewire\Component;

class SupervisorRecap extends Component
{
    public $staffs;
    public $viewRecap = false;
    public function render()
    {
        $staffs = Staff::where('program_id', Auth::user()->staff->program_id)->get();
        return view('livewire.specialization.research.components.supervisor-recap',[
            'staffs' => $staffs,
        ]);
    }
    public function viewRecap(){
        if($this->viewRecap == true){
            $this->viewRecap = false;
        }else{
            $this->viewRecap = true;
        }
    }
}
