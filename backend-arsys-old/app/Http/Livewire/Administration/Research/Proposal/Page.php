<?php

namespace App\Http\Livewire\Administration\Research\Proposal;


use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $search;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    protected $listeners = ['refresh_ArSysAdministrationResearchNewPage' => '$refresh',
                            'closeView_ArSysAdministrationResearchNewPage'];
    public $viewResearch = false;
    public $programId;
    public function render()
    {
        $programs = null;
        $researchs = null;
        if( Auth::user()->staff->program){

            $programs = Program::whereHas('cluster', function($query){
                $query->where('cluster_base_id', Auth::user()->staff->program->cluster->id );
            })
            ->get();

        }
        if($this->programId){
            $researchs = Research::whereHas('active')
            ->whereHas('student', function($query){
                $query->where('program_id', $this->programId);
            })
            ->whereHas('SIASPro', function($query){
                $query->where('status', 1);
            })
            ->paginate(10);
        //->get();
            if(!is_null($this->search)){
                $researchs = Research::whereHas('active')
                ->whereHas('student', function($query){
                    $query->where('program_id', $this->programId)
                        ->where('first_name','like', '%'.$this->search.'%')
                        ->orwhere('last_name','like', '%'.$this->search.'%')
                        ->orwhere('number','like', '%'.$this->search.'%');
                })

                ->whereHas('SIASPro', function($query){
                        $query->where('status', 1);
                    })
                ->paginate(10);
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
        }

        return view('livewire.administration.research.proposal.page',
            ['researchs' => $researchs,
                'programs' => $programs,
            ]);
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearch = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        $this->emit('viewResearch_ArSysAdministrationResearchView', $researchId);
    }
    public function SIASApprove($researchId){
        $research = Research::find($researchId);
        if($research->SIASPro->status == 1){
            $research->SIASPro->update([
                'status' => null,
            ]);
        }else{
            $research->SIASPro->update([
                'status' => 1,
            ]);
        }
    }


    public function closeView_ArSysAdministrationResearchNewPage(){
        $this->viewResearch = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
        $this->expandViewIndex[$this->tempIndex] = 0;

    }
    public function hydrate(){
        $this->emit('reloadSelectProgram');
    }
}
