<?php

namespace App\Http\Livewire\SuperAdmin\Utilities\ResetSp;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchMilestoneLog;
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
        $researchs = Research::whereHas('student', function($query){
                return $query->where('program_id', 3);
            })
            //->whereHas('submit')
            //->orWhereHas('renewal')
            ->orderBy('type_id', 'DESC')
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->paginate(10);

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
        return view('livewire.super-admin.utilities.reset-sp.page', ['researchs' => $researchs]);
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function created($researchId){
        $research = Research::find($researchId);
        $code = ResearchType::where('program_id', $research->student->program_id)->where('id',12)->first()->data->code
                                .'-'.$research->student->number.'-'.(strval(1));
        Research::find($researchId)->update([
            'milestone_id' => 18,
            'type_id' => 12,
        ]);
        ResearchMilestoneLog::where('research_id',$researchId)->update([
            'milestone_id' => 18,
            //'type_id' => 12,
        ]);
    }
    public function submitted($researchId){
        $research = Research::find($researchId);
        $code = ResearchType::where('program_id', $research->student->program_id)->where('id',12)->first()->data->code
                                .'-'.$research->student->number.'-'.(strval(1));
        Research::find($researchId)->update([
            'milestone_id' => 19,
            'type_id' => 12,
        ]);
        ResearchMilestoneLog::where('research_id',$researchId)->update([
            'milestone_id' => 19,
        ]);
    }
    public function review($researchId){
        $research = Research::find($researchId);
        $code = ResearchType::where('program_id', $research->student->program_id)->where('id',12)->first()->data->code
                                .'-'.$research->student->number.'-'.(strval(1));
        Research::find($researchId)->update([
            'milestone_id' => 20,
            'type_id' => 12,
        ]);
        ResearchMilestoneLog::where('research_id',$researchId)->update([
            'milestone_id' => 20,
        ]);
    }

    public function delete($researchId){
        Research::find($researchId)->delete();
    }
}
