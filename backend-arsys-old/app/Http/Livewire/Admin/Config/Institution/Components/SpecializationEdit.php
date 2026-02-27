<?php

namespace App\Http\Livewire\Admin\Config\Institution\Components;

use App\Models\ArSys\Specialization;
use App\Models\ArSys\Staff;
use Auth;
use Illuminate\Support\Str;
use Livewire\Component;

class SpecializationEdit extends Component
{

    public $codeEdit;
    public $descriptionEdit;
    public $responsiblePersonId;
    public $responsibleName;
    public $specializationId;
    public $specialization;

    protected $listeners = ['specializationEdit_AdminInstitutionSpecialization',
                            'pickUpStaffName' => 'pickUpStaffName'];
    public function render()
    {
        if($this->responsiblePersonId){
            $staff = Staff::find($this->responsiblePersonId);
            $this->responsibleNameEdit = $staff->front_title.' '.
                                    $staff->first_name.' '.
                                    $staff->last_name.', '.
                                    $staff->rear_title;
        }else{
            $this->responsibleNameEdit = null;
        }
        $staffs = Staff::all();
        return view('livewire.admin.config.institution.components.specialization-edit',
                [
                    'specialization' => $this->specialization,
                    'staffs' => $staffs,
                ]);
    }



    public function specializationEdit_AdminInstitutionSpecialization($specializationId){
        $this->specializationId = $specializationId;
        $this->specialization = Specialization::where('id', $this->specializationId)->first();
        $this->codeEdit = $this->specialization->code;
        $this->descriptionEdit = $this->specialization->description;
        $this->responsiblePersonId = $this->specialization->staff_id;

    }
    public function updateSpecialization_ArSysAdminConfigInstitutionPage(){
        Specialization::find($this->specializationId)->update([
            'code' => Str::upper($this->codeEdit),
            'description' => Str::title($this->descriptionEdit),
            'program_id' => Auth::user()->sysrole->program_id,
            'staff_id' => $this->responsiblePersonId,
        ]);
        $this->codeCreate = null;
        $this->descriptionCreate = null;
        $this->emitUp('refresh__ArSysAdminConfigInstitutionPage');
    }

    public function pickUpStaffName($staffId){
        $this->responsiblePersonId  = $staffId;
    }

}
