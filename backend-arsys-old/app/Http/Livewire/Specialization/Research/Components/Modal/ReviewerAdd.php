<?php

namespace App\Http\Livewire\Specialization\Research\Components\Modal;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchReview;
use App\Models\ArSys\Staff;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class ReviewerAdd extends Component
{
    protected $listeners = ['reviewerAdd_ArSysSpecializationResearchComponentsModalReviewerAdd' => 'setReviewer',
                            'unAssignReviewer_ArSysSpecializationResearchComponentsModalReviewerAdd' => 'unAssign'];
    public $researchId = null;
    public $search;
    public $includeCluster = false;
    use WithPagination;
    protected $pageName = 'reviewerAdd';
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $research = Research::where('id', $this->researchId)->first();
        $staffs = null;
        $programs = null;
        $this->includeCluster = true;
        if($research){
            $programs = Program::whereHas('cluster', function($query){
                $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
            })
            ->get();
            if($this->includeCluster){
                $staffs = Staff::whereHas('program', function($query)use($research){
                        $query->whereHas('cluster', function($query)use($research){
                            $query->where('cluster_base_id', $research->student->program->cluster->data->id);
                        });
                    })
                    /*->addSelect(['supervisor' => ResearchSupervisor::selectRaw('sum(supervisor_id) as total_supervisor')
                        ->whereColumn('supervisor_id', 'id')
                        ->groupBy('supervisor_id')
                    ])
                    ->orderBy('supervisor', 'ASC')*/
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }else{
                $staffs = Staff::where('program_id', $research->student->program_id)
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }

            if ($this->search != null) {
                $staffs = Staff::where('first_name', 'like', '%' . $this->search . '%')
                    ->orwhere('last_name', 'like', '%' . $this->search . '%')
                    ->orwhere('code', 'like', '%' . $this->search . '%')
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }
        }
        return view('livewire.specialization.research.components.modal.reviewer-add',compact('staffs', 'research', 'programs'));
    }

    public function setReviewer($id){
        $this->researchId = $id;
        $this->emit('addReviewer_ArSysSpecializationResearchReviewerAddModal');
    }

    public function assign($staffId){

        if(is_null(ResearchReview::where('research_id', $this->researchId)
            ->where('reviewer_id', $staffId)
            ->first())){
            ResearchReview::Create([
                'research_id' => $this->researchId,
                'reviewer_id' => $staffId,
            ]);
        }
        $this->emit('refresh_ArSysSpecializationResearchNewPage');
        $this->emitUp('refresh_ArSysSpecializationResearchNewReviewer');
    }

    public function unAssign($reviewId){
        if(Research::where('id', $this->researchId)->first()->milestone_id == 2){
            ResearchReview::where('id', $reviewId)->delete();
        }elseif(Research::where('id', $this->researchId)->first()->milestone_id == 3
            && ResearchReview::where('research_id', $this->researchId)->get()->count() > 1){
            ResearchReview::where('id', $reviewId)->delete();
        }

        $this->emit('refresh_ArSysSpecializationResearchNewPage');
        $this->emitUp('refresh_ArSysSpecializationResearchNewReviewer');
    }
    public function includeCluster(){
        if($this->includeCluster){
            $this->includeCluster = false;
        }else{
            $this->includeCluster = true;
        }
    }
}
