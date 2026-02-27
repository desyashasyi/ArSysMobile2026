<?php

namespace App\Http\Livewire\Specialization\Research\NewProposal;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchRemark;
use App\Models\ArSys\ResearchType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $search;
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
        $researchs = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('submit')
        ->orWhereHas('renewal')
        ->orderBy('type_id', 'DESC')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->paginate($perPage = 10, $columns = ['*'], $pageName = 'researchProposalPage');

        if($this->search){
            $researchs = Research::whereHas('student', function($query){
                return $query->where('number','like', '%'.$this->search.'%')
                    ->orwhere('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%')
                    ->where('program_id', Auth::user()->staff->program_id);
            })
            ->whereHas('submit')
            ->orWhereHas('renewal')
            ->orderBy('type_id', 'DESC')
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->paginate(1);
        }
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
        return view('livewire.specialization.research.new-proposal.page', ['researchs' => $researchs]);
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

    public function closeView_ArSysSpecializationResearchPage(){
        $this->viewResearch = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
        $this->expandViewIndex[$this->tempIndex] = 0;

    }

    public function notifyStudent($researchId){
        ResearchRemark::create([
            'discussant_id' => Auth::user()->id,
            'research_id' => $researchId,
            'message' => '<p style="margin:0">Your proposal submission has been received.
                        Please be patient, the assignment of reviewer/supervisor is processing</p>',
        ]);
    }

    public function selectResearchType($researchTypeId){
        $this->researchTypeId = $researchTypeId;
    }
}
