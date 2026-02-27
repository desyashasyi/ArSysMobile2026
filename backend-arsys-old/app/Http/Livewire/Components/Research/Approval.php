<?php

namespace App\Http\Livewire\Components\Research;

use App\Models\ArSys\DefenseApproval;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Carbon\Carbon;
use Livewire\Component;

class Approval extends Component
{
    public $research;
    public $researchId;
    protected $listeners = ['refreshApproval_ArSysComponentsResearchApproval' => '$refresh'];
    public function render()
    {
        $this->research = Research::find($this->researchId);
        return view('livewire.components.research.approval');
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function predefenseApproval($approvalId){
        if(DefenseApproval::find($approvalId)->decision == null){
            DefenseApproval::find($approvalId)->update([
                'decision' => 1,
                'approval_date' => Carbon::now(),
            ]);
            /**
             * Send notification to student that Pre-defense request has been approved
             */
            $research = Research::find(DefenseApproval::find($approvalId)->research_id);
            $text = 'Hi '.$research->student->first_name.', '.DefenseApproval::find($approvalId)->staff->code.
                    ' has approved your request of your defense approval';
            //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', DefenseApproval::find($approvalId)->staff->user->id, $text);
        }else{
            DefenseApproval::find($approvalId)->update([
                'decision' => null,
                'approval_date' => null,
            ]);
        }
        /*
        if(!(Research::find($this->researchId)
            ->predefenseApproval->contains('decision', null))){

            Research::find($this->researchId)->increment('milestone_id');
            if(is_null(Research::find($this->researchId)->DEFAPPROVED)){
                ResearchLog::create([
                    'research_id' => DefenseApproval::find($approvalId)->research_id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','DEFAPPROVED')->first()->id,
                    'message' => ResearchLogType::where('code','DEFAPPROVED')->first()->description,
                    'status' => 1,
                ]);
            }
        }else{
              //Decrement milestone
            Research::find(DefenseApproval::find($approvalId)->research_id)->decrement('milestone_id');
        }*/
        if(Research::find($this->researchId)
            ->predefenseApproval->count() == (Research::find($this->researchId)
            ->predefenseApproved->count())){
                Research::find($this->researchId)->update([
                    'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')->where('phase', 'Approved')->first()->id,
                ]);
            }else{
                Research::find($this->researchId)->update([
                    'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')->where('phase', 'Submitted')->first()->id,
                ]);
            }

        $this->emit('refresh_ArSysStaffResearchPage');
        $this->emit('refreshView_ArSysStudentResearchView');
        $this->emit('refreshInformation_ArSysComponentsResearchInformation');
    }

    public function finaldefenseApproval($approvalId){
        if(DefenseApproval::find($approvalId)->decision == null){
            DefenseApproval::find($approvalId)->update([
                'decision' => 1,
                'approval_date' => Carbon::now(),
            ]);
            /**
             * Send notification to student that Pre-defense request has been approved
             */
            $research = Research::find(DefenseApproval::find($approvalId)->research_id);
            $text = 'Hi '.$research->student->first_name.', '.DefenseApproval::find($approvalId)->staff->code.
                    ' has approved your request of your final defense approval';
            //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', DefenseApproval::find($approvalId)->staff->user->id, $text);
        }else{
            DefenseApproval::find($approvalId)->update([
                'decision' => null,
                'approval_date' => null,
            ]);
        }
        if(Research::find($this->researchId)->finaldefenseApproval->count() == Research::find($this->researchId)->finaldefenseApproved->count()){
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                ->where('phase', 'Approved')->where('sequence', 12)->first()->id,
            ]);
            if(is_null(Research::find($this->researchId)->PUBAPPROVED)){
                ResearchLog::create([
                    'research_id' => DefenseApproval::find($approvalId)->research_id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','PUBAPPROVED')->first()->id,
                    'message' => ResearchLogType::where('code','PUBAPPROVED')->first()->description,
                    'status' => 1,
                ]);
            }
        }else{
              //Decrement milestone
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                ->where('phase', 'Submitted')->where('sequence', 11)->first()->id,
            ]);
        }
        $this->emit('refresh_ArSysStaffResearchPage');
        $this->emit('refreshView_ArSysStudentResearchView');
        $this->emit('refreshInformation_ArSysComponentsResearchInformation');
    }

    public function seminarApproval($approvalId){
        if(DefenseApproval::find($approvalId)->decision == null){
            DefenseApproval::find($approvalId)->update([
                'decision' => 1,
                'approval_date' => Carbon::now(),
            ]);
            /**
             * Send notification to student that Pre-defense request has been approved
             */
            $research = Research::find(DefenseApproval::find($approvalId)->research_id);
            $text = 'Hi '.$research->student->first_name.', '.DefenseApproval::find($approvalId)->staff->code.
                    ' has approved your request of your seminar approval';
            //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', DefenseApproval::find($approvalId)->staff->user->id, $text);
        }else{
            DefenseApproval::find($approvalId)->update([
                'decision' => null,
                'approval_date' => null,
            ]);
        }
        if(!(Research::find($this->researchId)
            ->seminarApproval->contains('decision', null))){
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                ->where('phase', 'Approved')->where('sequence', 6)->first()->id,
            ]);
            if(is_null(Research::find($this->researchId)->SEMAPPROVED)){
                ResearchLog::create([
                    'research_id' => DefenseApproval::find($approvalId)->research_id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','SEMAPPROVED')->first()->id,
                    'message' => ResearchLogType::where('code','SEMAPPROVED')->first()->description,
                    'status' => 1,
                ]);
            }
        }else{
              //Decrement milestone
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                ->where('phase', 'Submitted')->where('sequence', 5)->first()->id,
            ]);
        }
        $this->emit('refresh_ArSysStaffResearchPage');
        $this->emit('refreshView_ArSysStudentResearchView');
        $this->emit('refreshInformation_ArSysComponentsResearchInformation');
    }

}
