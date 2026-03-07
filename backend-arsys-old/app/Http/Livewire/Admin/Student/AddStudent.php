<?php

namespace App\Http\Livewire\Admin\Student;

use App\Models\ArSys\Program;
use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use Livewire\Component;

class AddStudent extends Component
{
    public $faculty;
    public $department;
    public $studentProgram;
    public $studentSpecialization;
    public $studentSupervisor;
    public $firstName;
    public $lastName;
    public $studentId;
    public $supervisor;
    public $phone;
    public $email;
    public $programs;

    protected $listeners = ['clearForm_AdminAddStudent' => 'clearForm'];

    public function render()
    {
        if (!is_null($this->studentProgram)) {
            $this->specializations = Specialization::where('program_id', $this->studentProgram)->get();
            $this->department = Program::where('id', $this->studentProgram)->first()->department->code.'-'.
                                Program::where('id', $this->studentProgram)->first()->department->description;
            $this->faculty = Program::where('id', $this->studentProgram)->first()->department->faculty->code.'-'.
                             Program::where('id', $this->studentProgram)->first()->department->faculty->name;
            $this->supervisors = Staff::where('program_id', $this->studentProgram)->get();
        }
        return view('livewire.admin.user.components.student.add');
    }
    public function mount(){
        $this->programs = Program::all();
        $this->specializations = collect();
        $this->supervisors = collect();
        $this->clearForm();
    }

    public function hydrate(){
        $this->emit('reloadSelectStudentProgram');
        $this->emit('reloadSelectStudentSpecialization');
        $this->emit('reloadSelectStudentSupervisor');
    }

    public function clearForm(){

        $this->resetErrorBag();
        $this->resetValidation();
        $this->faculty = '';
        $this->department = '';
        $this->specialization = '';

        $this->firstName = '';
        $this->lastName = '';
        $this->studentId = '';
        $this->supervisor = '';
        $this->phone = '';
        $this->email = '';
    }

}
