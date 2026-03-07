<?php

namespace App\Http\Livewire\Admin\Config\Research;

use App\Models\ArSys\ResearchType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Type extends Component
{
    public $viewResearchType;
    public $search;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    public function render()
    {
        $researchTypes = null;
        if(Auth::user()->sysrole){
            $researchTypes = ResearchType::where('program_id', Auth::user()->sysrole->program_id)
                    ->paginate($perPage = 10, $columns = ['*'], $pageName = 'researchTypePage');
        }

        if($this->pageNumber != $researchTypes->currentPage()){
            foreach($researchTypes as $index => $typpe){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $researchTypes->currentPage();
            $this->tempIndex = $researchTypes->count()+1;
            $this->viewIndex = $researchTypes->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewResearchType == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.admin.config.research.type', ['researchTypes' => $researchTypes]);
    }
    public function mount(){
        $this->viewResearchType = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearchType = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }

    public function setSuperviseDurationConfig($configId){
        if(ResearchType::find($configId)->enable_week_of_supervise == 1){
            ResearchType::find($configId)->update([
                'enable_week_of_supervise' => null,
            ]);
        }else{
            ResearchType::find($configId)->update([
                'enable_week_of_supervise' => 1,
            ]);
        }
    }

    public function setResearchTypeConfig($configId){
        if(ResearchType::find($configId)->status == 1){
            ResearchType::find($configId)->update([
                'status' => null,
            ]);
        }else{
            ResearchType::find($configId)->update([
                'status' => 1,
            ]);
        }
    }

    public function decSupervisorNumber($researchTypeId){
        ResearchType::find($researchTypeId)->decrement('supervisor_number');
        $this->render();
    }
    public function incSupervisorNumber($researchTypeId){
        ResearchType::find($researchTypeId)->increment('supervisor_number');
        $this->render();
    }

    public function decSuperviseDuration($researchTypeId){
        ResearchType::find($researchTypeId)->decrement('week_of_supervise');
        $this->render();
    }
    public function incSuperviseDuration($researchTypeId){
        ResearchType::find($researchTypeId)->increment('week_of_supervise');
        $this->render();
    }


}
