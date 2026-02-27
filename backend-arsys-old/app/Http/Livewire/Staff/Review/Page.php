<?php

namespace App\Http\Livewire\Staff\Review;

use App\Models\ArSys\Research;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    protected $listeners = ['refresh_ArSysStaffResearchReviewPage' => '$refresh',
                            'closeView_ArSysStaffResearchReviewPage'];
    public $viewResearch = false;
    public function render()
    {
        $researchs = Research::whereHas('reviewer', function($query){
            return $query->where('reviewer_id', Auth::user()->staff->id)
                ->where('approval_date', null);
        })
        ->whereHas('review')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
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
        return view('livewire.staff.review.page', ['researchs' => $researchs]);
    }

    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
        $this->viewResearch = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearch = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        $this->emit('viewResearch_ArSysStaffResearchReviewView', $researchId);
    }


    public function closeView_ArSysStaffResearchReviewPage(){
        $this->viewStudent = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
    }
}
