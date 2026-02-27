<?php

namespace App\Http\Livewire\Specialization\Research\InProgress;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchSuperviseDurationDisable;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\ResearchType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $search;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    protected $paginationTheme = 'bootstrap';

    protected $listeners = ['refresh_ArSysSpecializationResearchNewPage' => '$refresh',
                            'closeView_ArSysSpecializationResearchInProgressPage'];
    public $viewResearch = false;
    public function render()
    {
        $this->researchTypes = ResearchType::where('program_id', Auth::user()->staff->program_id)
        ->whereHas('data',function($query){
            $query->where('level_id', Program::find(Auth::user()->staff->program_id)->level_id);
        })
        ->get();
        $researchs = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('active')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->paginate($perPage = 10, $columns = ['*'], $pageName = 'researchProposalPage');

        $numberOfResearchs = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('active')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->get();

        if($this->search){
            $researchs = Research::whereHas('student', function($query){
                return $query->where('number','like', '%'.$this->search.'%')
                    ->orwhere('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%')
                    ->where('program_id', Auth::user()->staff->program_id);
            })
            ->whereHas('active')
            ->orderBy('type_id', 'DESC')
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->paginate(1);
        }
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
        return view('livewire.specialization.research.in-progress.page',
            [
                'researchs' => $researchs,
                'numberOfResearchs' => $numberOfResearchs
            ]
        );
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearch = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }
    public function closeView_ArSysSpecializationResearchInProgressPage(){
        $this->viewStudent = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
    }

    public function unAssign($supervisorId){
        ResearchSupervisor::find($supervisorId)->delete();
    }

    public function disableSuperviseDuration($researchId){
        if(Research::where('id', $researchId)->first()->disableSuperviseDuration){
            ResearchSuperviseDurationDisable::where('research_id',$researchId)->delete();
        }else{
            ResearchSuperviseDurationDisable::create([
                'research_id' => $researchId,
            ]);
        }
    }

    public function setConfig($configId){
        if(ResearchConfig::find($configId)->status == null){
            ResearchConfig::find($configId)->update([
                'status' => 1,
            ]);
        }else{
            ResearchConfig::find($configId)->update([
                'status' => null,
            ]);
        }
    }
}
