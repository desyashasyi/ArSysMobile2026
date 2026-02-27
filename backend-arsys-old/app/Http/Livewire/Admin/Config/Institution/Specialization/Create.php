<?php

namespace App\Http\Livewire\Admin\Config\Institution\Specialization;

use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use App\Models\User;
use Auth;
use Illuminate\Support\Str;
use Livewire\Component;

class Create extends Component
{
    public $addSpecialization = false;
    public $codeCreate;
    public $descriptionCreate;
    public $responsibleNameCreate;
    public $responsiblePersonId;
    public $headOfSpecializationCreate;
    protected $listeners = ['pickUpStaffName' => 'pickUpStaffName'];
    public function render()
    {
        if($this->headOfSpecializationCreate){
            $staff = Staff::find($this->headOfSpecializationCreate);
            $this->responsibleNameCreate = $staff->front_title.' '.
                                    $staff->first_name.' '.
                                    $staff->last_name.', '.
                                    $staff->rear_title;
        }else{
            $this->responsibleNameCreate = null;
        }
        return view('livewire.admin.config.institution.specialization.create');
    }

    public function addSpecialization_AdminConfigInstitutionPage(){
        if($this->addSpecialization){
            $this->addSpecialization = false;
        }else{
            $this->addSpecialization = true;
            $this->editSpecialization = false;
        }
    }

    protected $rules =[
        'codeCreate' => 'required',
        'descriptionCreate' => 'required',
        //'headOfSpecializationCreate' => 'required',
    ];

    protected $messages =[
        'codeCreate.required' => 'The specialization code is mandatory',
        'descriptionCreate.required' => 'The description of specialization is mandatory',
        //'headOfSpecializationCreate.required' => 'The head of specialization is mandatory',
    ];
    public function saveSpecialization_ArSysAdminConfigInstitutionPage(){
        $this->validate();
        Specialization::updateOrCreate([
            'code' => Str::upper($this->codeCreate),
            'description' => Str::title($this->descriptionCreate),
            'program_id' => Auth::user()->sysrole->program_id,
            //'staff_id' => $this->responsiblePersonId,
            'staff_id' => $this->headOfSpecializationCreate,
        ]);

        /**
         * Attach role of head program
         */
        if($this->headOfSpecializationCreate){
            $staff = Staff::find($this->headOfSpecializationCreate);

            if(is_null(User::where('name',$staff->code)->first())){
                User::create([
                    'name' => $staff->code,
                    'sso' => $staff->sso,
                ]);
            }
            Staff::find($this->headOfSpecializationCreate)->update([
                'user_id' => User::where('name',$staff->code)->first()->id,
            ]);

            User::where('name',$staff->code)->first()->assignRole('specialization');
        }


        $this->codeCreate = null;
        $this->descriptionCreate = null;
        $this->headOfSpecializationCreate =null;
        $this->emitUp('refresh_ArSysAdminConfigInstitutionSpecializationPage');
    }

    public function pickUpStaffName($staffId){
        $this->headOfSpecializationCreate  = $staffId;
    }

}
