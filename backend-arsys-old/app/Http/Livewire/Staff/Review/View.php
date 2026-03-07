<?php

namespace App\Http\Livewire\Staff\Review;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchReview;
use App\Models\ArSys\ResearchReviewDecisionType;
use Auth;
use Livewire\Component;

class View extends Component
{
    protected $listeners = ['viewResearch_ArSysStaffResearchReviewView', 'refresh_ArSysStaffResearchReviewView' => '$refresh'];

    public $research;
    public $researchId;
    public function render()
    {
        if($this->researchId){
            $this->research = Research::where('id', $this->researchId)->first();
        }
        return view('livewire.staff.review.view');
    }

    public function viewResearch_ArSysStaffResearchReviewView($researchId){
        $this->researchId = $researchId;
        $this->emit('researchRemark_SpecializationResearchPage', $researchId);
    }

    public function accept(){
        ResearchReview::where('research_id',$this->researchId)
            ->where('reviewer_id', Auth::user()->staff->id)->update([
                'decision_id' => ResearchReviewDecisionType::where('code', 'APP')->first()->id,
            ]);
        $this->emit('refresh_ArSysStaffResearchReviewPage');
    }

    public function reject(){
        ResearchReview::where('research_id',$this->researchId)
            ->where('reviewer_id', Auth::user()->staff->id)->update([
                'decision_id' => ResearchReviewDecisionType::where('code', 'RJC')->first()->id,
            ]);
        $this->emit('refresh_ArSysStaffResearchReviewPage');
    }

}
