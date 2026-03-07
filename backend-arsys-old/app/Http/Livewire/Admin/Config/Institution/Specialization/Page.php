<?php

namespace App\Http\Livewire\Admin\Config\Institution\Specialization;

use App\Models\ArSys\InstitutionConfig;
use App\Models\ArSys\Specialization;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $enableSpecialization = false;
    public $addSpecialization = false;
    use WithPagination;
    public $viewSpecializationIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageNumber = null;
    public $viewSpecialization = false;
    protected $paginationTheme = 'bootstrap';

    protected $listeners = ['viewSpecializationPage_ArSysAdminConfigInstitutionPage',
                            'refresh_ArSysAdminConfigInstitutionSpecializationPage',
                            ];
    public function render()
    {
        $specializations = Specialization::where('program_id', Auth::user()->sysrole->program_id)
                            ->paginate(5);
        if($this->pageNumber != $specializations->currentPage()){
            foreach($specializations as $index => $specialization){
                $this->viewSpecializationIndex[$index] = null;
            }
            $this->pageNumber = $specializations->currentPage();
            $this->tempIndex = $specializations->count()+1;
            $this->viewIndex = $specializations->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->viewSpecializationIndex[$this->viewIndex] = 1;
            $this->viewSpecializationIndex[$this->tempIndex] = null;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewSpecialization == true){
                $this->viewSpecializationIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.admin.config.institution.specialization.page',
            [
                'specializations' => $specializations,
            ]);
    }

    public function mount(){
        $this->enableSpecialization = false;
    }


    public function viewSpecializationPage_ArSysAdminConfigInstitutionPage($configId){
        if(InstitutionConfig::find($configId)->status == 1){
            $this->enableSpecialization = true;
        }else{
            $this->enableSpecialization = false;
        }
    }

    public function deleteSpecialization($specializationId){
        Specialization::find($specializationId)->delete();
    }

    public function addSpecialization(){
        $this->addSpecialization = true;
    }

    public function refresh_ArSysAdminConfigInstitutionSpecializationPage(){

    }
}
