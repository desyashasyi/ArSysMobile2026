<?php

namespace App\Http\Livewire\Admin\Staff;

use App\Models\ArSys\Program;
use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use App\Models\ArSys\StaffPosition;
use App\Models\ArSys\StaffRole;
use App\Models\ArSys\StaffStatus;
use App\Models\ArSys\StaffStructure;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Create extends Component
{
    use LivewireAlert;
    public $addStaff = false;
    public $facultyCreate;
    public $departmentCreate;
    public $programCreate;
    public $specializationCreate;
    public $positionCreate;
    public $structureCreate;


    public $firstNameCreate;
    public $lastNameCreate;
    public $frontTitleCreate;
    public $rearTitleCreate;
    public $codeCreate;
    public $univCodeCreate;
    public $employeeIdCreate;
    public $jobRoleCreate = [];
    public $phoneCreate;
    public $emailCreate;

    public $programs;
    public $specializations;
    public $positions;
    public $structures;
    public $jobRoles;

    protected $listeners = ['addStaffDisable_AdminStaffCreate'];
    public function render()
    {
        if (!is_null($this->programCreate)) {
            $this->specializations = Specialization::where('program_id', $this->programCreate)->get();
            if(!is_null(Program::where('id', $this->programCreate)->first()->department)){
                $this->department = Program::where('id', $this->programCreate)->first()->department->code.'-'.
                                    Program::where('id', $this->programCreate)->first()->department->description;
            }
            if(!is_null(Program::where('id', $this->programCreate)->first()->department) && Program::where('id', $this->programCreate)->first()->department->faculty){
                $this->faculty = Program::where('id', $this->programCreate)->first()->department->faculty->code.'-'.
                                 Program::where('id', $this->programCreate)->first()->department->faculty->name;
            }

        }

        if(!is_null($this->positionCreate)){
            $this->structures = StaffStructure::where('position_id', $this->positionCreate)->get();
        }

        return view('livewire.admin.staff.create');
    }

    public function hydrate()
    {
        $this->emit('reloadSelectProgramCreate');
        $this->emit('reloadSelectSpecializationCreate');
        $this->emit('reloadSelectPositionCreate');
        $this->emit('reloadSelectStructureCreate');
        //$this->emit('reloadSelectJobRole');
    }

    public function mount(){
        $this->programs = Program::all();
        $this->positions = StaffPosition::all();
        $this->jobRoles = StaffRole::all();
        $this->specializations = collect();
        $this->structures = collect();
        $this->clearForm();
    }

    protected $rules = [
        'programCreate' => 'required',
        'specializationCreate' => 'required',
        'positionCreate' => 'required',
        'structureCreate' => 'required',
        'firstNameCreate' => 'required',
        'frontTitleCreate' => 'required',
        'rearTitleCreate' => 'required',
        'lastNameCreate' => 'required',
        'employeeIdCreate' => 'required',
        'codeCreate' => 'required',
        'univCodeCreate' => 'required',
        'phoneCreate' => 'required',
        'emailCreate' => 'required|email',
    ];
    protected $messages = [
            'program.required' => 'The Program of Study is required',
            'email.required' => 'The Email Address cannot be empty.',
    ];
    public function clearForm(){
        $this->resetErrorBag();
        $this->resetValidation();
        $this->facultyCreate = '';
        $this->departmentCreate = '';
        $this->specializationCreate = '';
        $this->positionCreate = '';
        $this->structureCreate = '';

        $this->firstNameCreate = '';
        $this->lastNameCreate = '';
        $this->frontTitleCreate = '';
        $this->rearTitleCreate = '';
        $this->codeCreate = '';
        $this->univCodeCreate = '';
        $this->employeeIdCreate = '';
        $this->jobRoleCreate = '';
        $this->phoneCreate = '';
        $this->emailCreate = '';
    }

    public function save(){
        $this->validate();
        if(is_null(Staff::where('employee_id', $this->employeeIdCreate)->first())){
            Staff::create([
                'program_id' => $this->programCreate,
                'specialization_id' => $this->specializationCreate,
                'position_id' => $this->positionCreate,
                'structure_id' => $this->structureCreate,
                'first_name' => $this->firstNameCreate,
                'last_name' => $this->lastNameCreate,
                'front_title' => $this->frontTitleCreate,
                'rear_title' => $this->rearTitleCreate,
                'code' => $this->codeCreate,
                'univ_code' => $this->univCodeCreate,
                'employee_id' => $this->employeeIdCreate,
                'phone' => $this->phoneCreate,
                'email' => $this->emailCreate,
                'status_id' => StaffStatus::where('code', 'ACT')->first()->id,
            ]);
            $staffId = Staff::where('employee_id', $this->employeeIdCreate)->first()->id;
            foreach($this->jobRole as $role){
                StaffRole::create([
                    'staff_id' => $staffId,
                    'staff_role_id' => $role,
                ]);
            }
            $this->alert('success', 'The profile has been recorded');
            $this->clearForm();
            $this->emitUp('staffViewRefresh');
        }
    }

    public function addStaffDisable_AdminStaffCreate(){
        $this->addStaff = false;
    }

    public function addStaff_AdminStaffPage(){
        if($this->addStaff){
            $this->addStaff = false;
        }else{
            $this->addStaff = true;
        }
    }
}
