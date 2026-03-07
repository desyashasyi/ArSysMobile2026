<?php

namespace App\Http\Livewire\Components\Dropdown;

use App\Models\ArSys\Program;
use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use Livewire\Component;

class ProfileStudent extends Component
{

    public $faculty;
    public $department;
    public $program;
    public $specialization;
    public $staff;

    public $programs;
    public $specializations;
    public $staffs;
    public $listeners = ['selectProgram', 'selectSpecialization', 'selectStaff'];
    public function render()
    {
        if (!is_null($this->program)) {
            $this->specializations = Specialization::where('program_id', $this->program)->get();
            $this->staffs = Staff::where('program_id', $this->program)->get();
            $this->department = Program::where('id', $this->program)->first()->department->code.'-'.
                                Program::where('id', $this->program)->first()->department->description;
            $this->faculty = Program::where('id', $this->program)->first()->department->faculty->code.'-'.
                             Program::where('id', $this->program)->first()->department->faculty->name;
        }
        return view('livewire.components.dropdown.profile-student');
    }
    public function mount(){
        $this->programs = Program::all();
        $this->specializations = collect();
        $this->staffs = collect();
    }

    public function selectProgram(){
        $this->emit('setProgram_UserProfileCreateFormStudent', ['program' => $this->program]);
    }

    public function selectSpecialization(){
        $this->emit('setSpecialization_UserProfileCreateFormStudent', ['specialization' => $this->specialization]);
    }

    public function selectStaff(){
        $this->emit('setSupervisor_UserProfileCreateFormStudent', ['supervisor' => $this->staff]);
    }

    public function hydrate()
    {
        $this->emit('reloadSelectSpecialization');
        $this->emit('reloadSelectStaff');
        $this->emit('reloadSelectProgram');
    }
}
