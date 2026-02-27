<?php

namespace App\Http\Livewire\SuperAdmin\Utilities\SetActiveResearch;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $researchTypeId;
    public $researchTypes;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    protected $listeners = ['refresh_ArSysSpecializationResearchPage' => '$refresh',
                            'closeView_ArSysSpecializationResearchPage',
                            'selectResearchType',
                            ];
    public $viewResearch = false;
    public function render()
    {
        /*$researchs = Research::where('type_id', $this->researchTypeId)
        ->whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        */

        $this->researchTypes = ResearchType::where('program_id', Auth::user()->staff->program_id)
            ->whereHas('data',function($query){
                $query->where('level_id', Program::find(Auth::user()->staff->program_id)->level_id);
            })
            ->get();
        $researchs = Research::whereHas('student')
            ->where('milestone_id', 4)
            ->orderBy('student_id', 'ASC')
            ->paginate(1000);

        if($researchs->isNotEmpty()){
            if($this->pageNumber != $researchs->currentPage()){
                foreach($researchs as $index => $research){
                    $this->expandViewIndex[$index] = null;
                }
                $this->pageNumber = $researchs->currentPage();
                $this->tempIndex = $researchs->count()+1;
                $this->viewIndex = $researchs->count()+1;
            }
            if($this->tempIndex != $this->viewIndex){
                $this->expandViewIndex[$this->viewIndex] = 1;
                $this->expandViewIndex[$this->tempIndex] = 0;
                $this->tempIndex = $this->viewIndex;
            }else{
                if($this->viewResearch == true){
                    $this->expandViewIndex[$this->viewIndex] = 1;
                }
            }
        }
        return view('livewire.super-admin.utilities.set-active-research.page', ['researchs' => $researchs]);
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function active($researchId){
        $research = Research::find($researchId);
    }

}
