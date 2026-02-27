<?php

namespace App\Http\Livewire\Student\Research;

use App\Models\ArSys\Research;
use Auth;
use Livewire\Component;

class Page extends Component
{
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageNumber = null;

    public $addResearch = false;
    public $viewResearch = false;
    public $editResearch = false;
    public $superviseMeeting = false;
    protected $listeners = ['addResearch_ArSysStudentResearchPage',
                            'refresh_ArSysStudentResearchPage' => '$refresh' ];
    public function render()
    {
        $researchs = Research::where('student_id', Auth::user()->student->id)
            ->orderBy('id','DESC')
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
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewResearch == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.student.research.page', ['researchs' => $researchs]);
    }

    public function addResearch_ArSysStudentResearchPage(){
        if(!$this->addResearch){
            $this->addResearch = true;
            $this->expandViewIndex[$this->viewIndex] = 0;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->viewResearch = false;
        }else{
            $this->addResearch = false;
        }
    }

    public function expandView($viewIndex, $researchId){
        $this->viewIndex = $viewIndex;
        $this->viewResearch = true;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
        $this->viewResearch = false;
        $this->addResearch = false;
    }
}
