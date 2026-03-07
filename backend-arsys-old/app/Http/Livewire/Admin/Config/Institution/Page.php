<?php

namespace App\Http\Livewire\Admin\Config\Institution;
use App\Http\Livewire\Arsys\Admin\Config\Institution\InstitutionRole;
use App\Http\Livewire\Arsys\Admin\Config\Institution\Program;
use App\Http\Livewire\Arsys\Admin\Config\Institution\User;
use App\Models\ArSys\InstitutionConfig;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $viewConfigIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageNumber = null;
    public $specializations =null;
    public $viewConfig = false;
    public $enableSpecialization = false;
    public $enableStudyCompletion = false;
    public $configCount = null;
    protected $listeners = ['editSpecializationDisable_ArSysAdminConfigInstitutionPage',
                            'refresh__ArSysAdminConfigInstitutionPage' => '$refresh'];
    public function render()
    {   $configs;
        if(Auth::user()->sysrole){
            $configs = InstitutionConfig::where('program_id', Auth::user()->sysrole->program_id)->paginate();
        }
        if($configs){
            if($this->pageNumber != $configs->currentPage()){
                foreach($configs as $index => $staff){
                    $this->viewConfigIndex[$index] = null;
                }
                $this->pageNumber = $configs->currentPage();
                $this->tempIndex = $configs->count()+1;
                $this->viewIndex = $configs->count()+1;
            }
            if($this->tempIndex != $this->viewIndex){
                $this->viewConfigIndex[$this->viewIndex] = 1;
                $this->viewConfigIndex[$this->tempIndex] = null;
                $this->tempIndex = $this->viewIndex;
            }else{
                if($this->viewConfig == true){
                    $this->viewConfigIndex[$this->viewIndex] = 1;
                }
            }
        }

        return view('livewire.admin.config.institution.page', ['configs' => $configs]);
    }

    public function mount(){
        $this->viewConfig = false;
    }

    public function expandViewConfig($viewId, $configId){
        $this->viewConfig = true;
        $this->viewIndex = $viewId;
        $this->viewConfigIndex[$this->viewIndex] = 1;
        $this->viewConfigIndex[$this->tempIndex] = 0;

        //$this->emit('specializationEdit_AdminInstitutionSpecialization', $specializationId);
        if(InstitutionConfig::find($configId)->data->code == 'SPECIALIZATION'){
            $this->enableSpecialization = true;
            $this->enableStudyCompletion = false;
            $this->enablePracticalWork = false;
            $this->emit('viewSpecializationPage_ArSysAdminConfigInstitutionPage', $configId);
        }
        if(InstitutionConfig::find($configId)->data->code == 'STUDY_COMPLETION'){
            $this->enableSpecialization = false;
            $this->enableStudyCompletion = true;
            $this->enablePracticalWork = false;
            $this->emit('viewStudyCompletionPage_ArSysAdminConfigInstitutionPage', $configId);

        }
    }



    public function setInstitutionConfig($configId){
        if(is_null(InstitutionConfig::find($configId)->status)){
            InstitutionConfig::find($configId)->update([
                'status' => 1,
            ]);
        }else{
            InstitutionConfig::find($configId)->update([
                'status' => null,
            ]);
        }
        if(InstitutionConfig::find($configId)->data->code == 'SPECIALIZATION'){
            $this->emit('viewSpecializationPage_ArSysAdminConfigInstitutionPage', $configId);
        }
    }
    public function loginAs($specializationId){
        $specializationHead = Program::find($programId)->code;
        if(User::find(InstitutionRole::where('code',$programCode.'-Admin' )->first()->user_id)){
            Auth::login(User::find(InstitutionRole::where('code',$programCode.'-Admin' )->first()->user_id));
            return redirect()->route('arsys.admin');
        }
    }

}
