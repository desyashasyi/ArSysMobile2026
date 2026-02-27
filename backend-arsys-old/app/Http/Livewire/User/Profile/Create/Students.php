<?php

namespace App\Http\Livewire\User\Profile\Create;

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
    public $program;
    public $specialization = null;
    Public $supervisor;
    public $studentNumber;
    public $phoneNumber;
    public $email;
    public $firstName;
    public $lastName;

    public $faculty;
    public $cluster;

    public $programs;
    public $specializations;
    public $staffs;
    public $listeners = ['setProgram_UserProfileCreateFormStudent',
                        'setSupervisor_UserProfileCreateFormStudent',
                        'setSpecialization_UserProfileCreateFormStudent'];
    public function render()
    {
        if($this->program) {
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

            $this->cluster = Program::where('id', $this->program)->first()->cluster->data->code.'-'.
                            Program::where('id', $this->program)->first()->cluster->data->name;
            $this->faculty = Program::where('id', $this->program)->first()->faculty->code.'-'.
                            Program::where('id', $this->program)->first()->faculty->name;

        }else{
            $this->cluster = null;
            $this->faculty = null;
            $this->specializations = collect();
            $this->staffs = collect();
        }
        $this->studentNumber = Auth::user()->sso;
        return view('livewire.user.profile.create.students');
    }

    public function mount(){
        $this->programs = Program::all();
        $this->specializations = collect();
        $this->staffs = collect();
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
    public function setProgram_UserProfileCreateFormStudent($program){
       $this->program = $program;
       $this->resetForm();
    }
    public function setSpecialization_UserProfileCreateFormStudent($specialization){
        $this->specialization = $specialization;
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
        'specialization' => 'required',
        'phoneNumber' => 'required',
        'email' => 'required|email',
        'firstName' => 'required',
        'lastName' => 'required',
    ];

    protected $messages = [
            'program.required' => 'The Program of Study is required',
            'email.required' => 'The Email Address cannot be empty.',
    ];

    public function save(){
        if($this->program){
            if(Program::find($this->program)->specialization->isEmpty()){
                $this->specialization = 0;
            }
        }

        $this->validate();

        if(is_null(Student::where('code', Auth::user()->sso)->first())){
            Student::create([
                'user_id' => Auth::user()->id,
                'program_id' => $this->program,
                'specialization_id' => $this->specialization,
                'supervisor_id' => $this->supervisor,
                'number' => $this->studentNumber,
                'code' => 's'.Auth::user()->sso,
                'first_name' => $this->firstName,
                'last_name' => $this->lastName,
                'email' => $this->email,
                'phone' => $this->phoneNumber,
            ]);
            $this->alert('success', 'The profile has been recorded');
            return redirect()->route('arsys.student.profile');
        }else{
            $this->alert('warning', 'The profile is already in database');
            return redirect()->route('arsys.student.profile');
        }
    }
}
