<?php

namespace App\Http\Livewire\User\Profile\Edit;

use App\Models\ArSys\Program;
use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use App\Models\ArSys\StaffType;
use App\Models\ArSys\Student;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Students extends Component
{
    use LivewireAlert;
    public $faculty;
    public $cluster;
    public $program;
    public $specialization;
    Public $supervisor;
    public $studentNumber;
    public $phoneNumber;
    public $email;
    public $firstName;
    public $lastName;


    public $programs;
    public $specializations;
    public $staffs;
    public $listeners = ['selectProgram',
                        'setSupervisor_UserProfileCreateFormStudent',
                        'setSpecialization_UserProfileCreateFormStudent'];
    public function render()
    {
        if (!is_null($this->program)) {
            $this->specializations = Specialization::where('program_id', $this->program)->get();
            $this->staffs = Staff::whereHas('program', function($query){
                            $query->whereHas('cluster', function($query){
                                    $query->where('cluster_base_id', Program::find($this->program)->cluster->data->id);
                                });
                            })
                            ->whereHas('type', function($query){
                                $query->where('id', StaffType::where('code', 'PTU')->first()->id)->orwhere('id', StaffType::where('code', 'PNS')->first()->id);
                            })
                            ->get();
            $this->cluster = Program::find($this->program)->cluster->data->code.'-'.
                                Program::find($this->program)->cluster->data->name;
            $this->faculty = Program::where('id', $this->program)->first()->faculty->code.'-'.
                             Program::where('id', $this->program)->first()->faculty->name;
        }
        return view('livewire.user.profile.edit.students');
    }
    public function mount(){
        $student = Student::where('user_id', Auth::user()->id)->first();
        if(!is_null($student->program)){
            $this->program = $student->program->id;
            $this->faculty = $student->program->faculty->name;
            $this->cluster = $student->program->cluster->data->name;
        }

        if(!is_null($student->specialization)){
            $this->specialization = $student->specialization->id;
        }

        if(!is_null($student->supervisor)){
            $this->supervisor = $student->supervisor->id;
        }
        $this->studentNumber = $student->number;
        $this->phoneNumber = $student->phone;
        $this->email = $student->email;
        $this->firstName = $student->first_name;
        $this->lastName = $student->last_name;;
        $this->programs = Program::all();
        $this->specializations = Specialization::where('program_id', $this->program)->get();
        $this->staffs = Staff::where('program_id', $this->program)->get();
    }

    public function hydrate()
    {
        $this->emit('reloadSelectSpecialization');
        $this->emit('reloadSelectStaff');
        $this->emit('reloadSelectProgram');
    }

    public function resetForm(){
        $this->resetErrorBag();
        $this->resetValidation();
    }
    public function selectProgram(){
        $this->specialization = null;
        $this->supervisor = null;
    }
    public function setSpecialization_UserProfileCreateFormStudent(){
        $this->resetForm();
    }
    public function setSupervisor_UserProfileCreateFormStudent($supervisor){
        $this->supervisor = $supervisor;
        $this->resetForm();
    }

    protected $rules = [
        'program' => 'required',
        'supervisor' => 'required',
        'studentNumber' => 'required|max:7',
        'phoneNumber' => 'required',
        'email' => 'required|email',
        'firstName' => 'required',
        'lastName' => 'required',
    ];
    protected $messages = [
            'program.required' => 'The Program of Study is required',
            'email.required' => 'The Email Address cannot be empty.',
    ];

    public function updateProfile(){
        $this->validate();

        if(!is_null(Student::where('number', Auth::user()->sso)->first())){
            $specialization = $this->specialization;
            Student::where('number', Auth::user()->sso)->
            update([
                'program_id' => $this->program,
                'specialization_id' => $specialization,
                'supervisor_id' => $this->supervisor,
                'number' => $this->studentNumber,
                'first_name' => $this->firstName,
                'last_name' => $this->lastName,
                'email' => $this->email,
                'phone' => $this->phoneNumber,
            ]);
            $this->alert('success', 'The profile has updated');
            return redirect()->route('arsys.student.profile');
        }
    }
}
