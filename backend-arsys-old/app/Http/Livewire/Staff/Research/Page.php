<?php

namespace App\Http\Livewire\Staff\Research;
use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;
use Browser;
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
    public $viewResearch = false;
    protected $listeners = ['refresh_ArSysStaffResearchPage' => '$refresh' ];
    public function render()
    {
        $this->researchTypes = ResearchType::where('program_id', Auth::user()->staff->program_id)
        ->whereHas('data',function($query){
            $query->where('level_id', Program::find(Auth::user()->staff->program_id)->level_id);
        })
        ->get();

        $researchs = Research::whereHas('supervisor', function($query){
            return $query->where('supervisor_id', Auth::user()->staff->id);
        })
        ->whereHas('active', function($query){
            $query->where('status', 1);
        })
        //->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'DESC')
        ->paginate(10);
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
            $this->expandViewIndex[$this->tempIndex] = null;
            $this->tempIndex = $this->viewIndex;
        }
        if(Browser::isMobile()){
            return view('livewire.staff.research.mobile.page', ['researchs' => $researchs]);
        }else{
            //return view('livewire.staff.research.mobile.page', ['researchs' => $researchs]);
            return view('livewire.staff.research.page', ['researchs' => $researchs]);
        }
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearch = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        //$this->researchId = $researchId;
    }

    public function closeView_ArSysSpecializationResearchPage(){
        $this->viewResearch = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
        $this->expandViewIndex[$this->tempIndex] = 0;

    }


}
