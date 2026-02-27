<?php

namespace App\Http\Livewire\Admin\Staff\Components;


use App\Models\ArSys\Program;
use App\Models\ArSys\Staff;
use App\Models\ArSys\StaffPosition;
use App\Models\ArSys\StaffStatus;
use App\Models\ArSys\StaffStructure;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Edit extends Component
{
    use LivewireAlert;

    public $programs;
    public $specializations;
    public $positions;
    public $structures;

    public $faculty;
    public $department;
    public $program;
    public $specialization;
    public $position;
    public $structure;

    public $firstName;
    public $lastName;
    public $frontTitle;
    public $rearTitle;
    public $code;
    public $univCode;
    public $employeeId;
    public $phone;
    public $email;
    public $staffId;
    public $listeners = ['editStaff_ArSysAdminStaffEdit'];

    public function render()
    {
        if (!is_null($this->program)) {
            $program = Program::find($this->program);
            $this->specializations = $program->specializations;
            $this->department = $program->department;
            $this->faculty = $this->department->faculty;

        }

        if(!is_null($this->position)){
            $this->structures = StaffStructure::where('position_id', $this->position)->get();
        }

        return view('livewire.admin.staff.components.edit');
    }

    public function hydrate()
    {
        $this->emit('reloadSelectProgram_AdminStaffEdit');
        $this->emit('reloadSelectSpecializationEdit');
        $this->emit('reloadSelectPositionEdit');
        $this->emit('reloadSelectStructureEdit');
    }

    public function editStaff_ArSysAdminStaffEdit($staffId){
        $staff = Staff::where('id', $staffId)->first();
        $this->staffId = $staffId;
        $this->program = $staff->program_id;
        $this->specialization = $staff->specialization_id;
        $this->position = $staff->position_id;
        $this->structure = $staff->structure_id;

        $this->firstName = $staff->first_name;
        $this->lastName = $staff->last_name;
        $this->frontTitle = $staff->front_title;
        $this->rearTitle =  $staff->rear_title;
        $this->code = $staff->code;
        $this->univCode = $staff->univ_code;
        $this->employeeId = $staff->employee_id;
        $this->phone = $staff->phone;
        $this->email = $staff->email;
        $this->programs = Program::all();
        $this->emit('editStaffModal_ArSysAdminStaffEdit');
    }
    public function mount(){
        $this->programs = Program::all();
        $this->positions = StaffPosition::all();
        $this->specializations = collect();
        $this->structures = collect();
    }

    protected $rules = [
        'program' => 'required',
        'specialization' => 'required',
        'position' => 'required',
        'structure' => 'required',
        'firstName' => 'required',
        'frontTitle' => 'required',
        'rearTitle' => 'required',
        'lastName' => 'required',
        'employeeId' => 'required',
        'code' => 'required',
        'univCode' => 'required',
        'phone' => 'required',
        'email' => 'required|email',
    ];
    protected $messages = [
        'program.required' => 'The Program of Study is required',
        'email.required' => 'The Email Address cannot be empty.',
    ];

    public function update(){
        $this->validate();
        if(!is_null(Staff::where('employee_id', $this->employeeId)->first())){
            Staff::where('employee_id', $this->employeeId)->update([
                'program_id' => $this->program,
                'specialization_id' => $this->specialization,
                'position_id' => $this->position,
                'structure_id' => $this->structure,
                'first_name' => $this->firstName,
                'last_name' => $this->lastName,
                'front_title' => $this->frontTitle,
                'rear_title' => $this->rearTitle,
                'code' => $this->code,
                'univ_code' => $this->univCode,
                'employee_id' => $this->employeeId,
                'phone' => $this->phone,
                'email' => $this->email,
                'status_id' => StaffStatus::where('code', 'ACT')->first()->id,
            ]);
            $staffId = Staff::where('employee_id', $this->employeeId)->first()->id;
            $this->alert('success', 'The profile has been updated');
        }
    }
}
