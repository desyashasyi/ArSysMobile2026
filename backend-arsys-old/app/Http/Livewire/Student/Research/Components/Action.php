<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\DefenseApproval;
use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\DefenseRole;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchMilestoneLog;
use App\Models\ArSys\ResearchType;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Action extends Component
{
    use LivewireAlert;
    public $researchId;
    public $delete;
    public $research = null;
    //protected $listeners = ['action_ArSysStudentResearchPage'];
    protected $listeners = ['refresh_ArSysStudentResearchAction' => '$refresh'];
    public function render()
    {
        $this->research = Research::where('id', $this->researchId)->first();
        return view('livewire.student.research.components.action');
    }
    public function mount ($researchId){
        $this->researchId = $researchId;
    }


    public function delete(){
        $this->delete = true;
    }

    public function deleteCancel(){
        $this->delete = false;
    }

    public function deleteProceed($researchId)
    {
        Research::destroy($researchId);
        $this->alert('success', 'The research proposal has been deleted');
        return redirect()->route('arsys.student.research');
    }


    public function researchProposal($researchId){
        $similarityPassed = null;
        $research = Research::find($researchId);
        $comparison = new \Atomescrochus\StringSimilarities\Compare();
        foreach(Research::all() as $researchDB){
            $this->result = $comparison->all($researchDB->title, $research->title);

            if($this->result['similar_text'] > 50.0 && $research->id != $researchId){
                $similarityPassed = 1;
            }
        }
        if(is_null($similarityPassed)){
            $researchCheck = false;
            $researchs = Research::where('student_id', Auth::user()->student->id)
            ->where('type_id', $research->type_id)
            /*->whereHas('history', function($query){
                $query->where('type_id', ResearchLogType::where('code', 'SUB')->first()->id)
                    ->orwhere('type_id', ResearchLogType::where('code', 'REV')->first()->id)
                    ->orwhere('type_id', ResearchLogType::where('code', 'ACT')->first()->id)
                    ->orwhere('type_id', ResearchLogType::where('code', 'FRE')->first()->id)
                    ->orwhere('type_id', ResearchLogType::where('code', 'REN')->first()->id)
                    ->where('status', 1);
            })*/

            ->get();

            foreach($researchs as $research){
                if ($research->submit || $research->review || $research->active || $research->freeze || $research->renewal || $research->SIASPro){
                    $researchCheck = true;
                }
            }

            if($researchCheck == false){
                if($research->write){
                    ResearchLog::where('research_id', $researchId)
                        ->where('type_id', ResearchLogType::where('code', 'CRE')->first()->id)
                        ->where('status', 1)
                        ->update([
                            'status' => null,
                    ]);
                    Research::find($researchId)->increment('milestone_id');
                    ResearchLog::create([
                        'research_id' => $researchId,
                        'loger_id' => Auth::user()->id,
                        'type_id' => ResearchLogType::where('code', 'SUB')->first()->id,
                        'message' => ResearchLogType::where('code', 'SUB')->first()->description,
                        'status' => 1,
                    ]);
                    //dd(ResearchType::where('id', $research->type_id)->first()->research_model_id);
                    //dd(ResearchType::where('program_id', Auth::user()->student->program_id)
                                    //->where('id', $research->type_id)->first()->data->research_model_id);
                    ResearchMilestoneLog::create([
                        'research_id' => $research->id,
                        'research_model_id' => ResearchType::where('program_id', Auth::user()->student->program_id)
                                                ->where('id', $research->type_id)->first()->data->research_model_id,
                        'milestone_id' => Research::find($researchId)->milestone_id,
                    ]);
                    $this->alert('success', 'The research proposal has been submitted');
                    $this->emit('refresh_ArSysStudentResearchPage');

                }

            }else{
                $this->alert('warning', 'You are already have active/review/submit research');
            }
        }else{
            $this->alert('danger', 'You could not submitted the research topic, it is 50% similar with another one');
        }



    }
    public function propose(){
        /**
        * Propose system for Defense model
        */
        if($research->type->research_model == 'defense'){
            if($research->milestone->sequence === 1){
                Research::find($researchId)->increment('research_milestone');

            }
        }

        if($research->type->research_model == 'seminar'){
            if($research->milestone->sequence === 1){
                Research::find($researchId)->increment('research_milestone');
            }
        }
        $this->emit('refreshStudentResearchView');
        $this->emit('refreshStudentResearchHeader');
    }

    public function preDefenseProposal($researchId){
        $research = Research::where('id', $researchId)->first();
        /**
        * Propose system for Defense model
        */

        if($research->milesPredefenseProgress){
            foreach($research->supervisor as $supervisor){
                DefenseApproval::create([
                    'approver_id' => $supervisor->staff->id,
                    'approver_role' => DefenseRole::where('code', 'SPV')->first()->id,
                    'research_id' => $research->id,
                    'defense_model_id' => DefenseModel::where('code', 'PRE')->first()->id,
                ]);

                /**
                 * Send notification by Telegram
                 */
                $text = 'Dear '.$supervisor->staff->code.', research '.$research->code.' by '
                        .$research->student->first_name.' '.$research->student->last_name.' ('.$research->student->number.
                        ') is need your approval for Pre-defense.';
                //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', $supervisor->staff->user->id, $text);
            }
            if(is_null($research->DEFAPPREQ)){
                ResearchLog::create([
                    'research_id' => $research->id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','DEFAPPREQ')->first()->id,
                    'message' => ResearchLogType::where('code','DEFAPPREQ')->first()->description,
                    'status' => 1,
                ]);
            }

            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')->where('phase', 'Submitted')->first()->id,
            ]);
            $this->emit('refresh_ArSysStudentResearchPage');
            $this->emit('refreshApproval_ArSysComponentsResearchApproval');
            $this->emit('refreshInformation_ArSysComponentsResearchInformation');

        }
    }


    public function finalDefenseProposal($researchId){
        $research = Research::where('id', $researchId)->first();
        /**
        * Propose system for Defense model
        */

        if($research->milesFinaldefenseProgress){
            foreach($research->supervisor as $supervisor){
                DefenseApproval::create([
                    'approver_id' => $supervisor->staff->id,
                    'approver_role' => DefenseRole::where('code', 'SPV')->first()->id,
                    'research_id' => $research->id,
                    'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                ]);

                /**
                 * Send notification by Telegram
                 */
                $text = 'Dear '.$supervisor->staff->code.', research '.$research->code.' by '
                        .$research->student->first_name.' '.$research->student->last_name.' ('.$research->student->number.
                        ') is need your approval for Final-defense.';
                //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', $supervisor->staff->user->id, $text);
            }
            DefenseApproval::create([
                'approver_id' => Auth::user()->student->program->staff_id,
                'approver_role' => DefenseRole::where('code', 'PRG')->first()->id,
                'research_id' => $research->id,
                'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
            ]);
            if(is_null($research->PUBAPPREQ)){
                ResearchLog::create([
                    'research_id' => $research->id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','PUBAPPREQ')->first()->id,
                    'message' => ResearchLogType::where('code','PUBAPPREQ')->first()->description,
                    'status' => 1,
                ]);
            }

            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')->where('phase', 'Submitted')->first()->id,
            ]);
            $this->emit('refresh_ArSysStudentResearchPage');
            $this->emit('refreshApproval_ArSysComponentsResearchApproval');
            $this->emit('refreshInformation_ArSysComponentsResearchInformation');

        }
    }


    public function seminarProposal($researchId){
        $research = Research::where('id', $researchId)->first();
        /**
        * Propose system for Defense model
        */

        if($research->milesSeminarProgress){
            foreach($research->supervisor as $supervisor){
                DefenseApproval::create([
                    'approver_id' => $supervisor->staff->id,
                    'approver_role' => DefenseRole::where('code', 'SPV')->first()->id,
                    'research_id' => $research->id,
                    'defense_model_id' => DefenseModel::where('code', 'SEM')->first()->id,
                ]);

                /**
                 * Send notification by Telegram
                 */
                $text = 'Dear '.$supervisor->staff->code.', research '.$research->code.' by '
                        .$research->student->first_name.' '.$research->student->last_name.' ('.$research->student->number.
                        ') is need your approval for Program Seminar.';
                //$this->emit('sendMessage_ArSysComponentsTelegramSendMessage', $supervisor->staff->user->id, $text);
            }

            if(is_null($research->SEMAPPREQ)){
                ResearchLog::create([
                    'research_id' => $research->id,
                    'loger_id' => Auth::user()->id,
                    'type_id' => ResearchLogType::where('code','SEMAPPREQ')->first()->id,
                    'message' => ResearchLogType::where('code','SEMAPPREQ')->first()->description,
                    'status' => 1,
                ]);
            }

            Research::find($researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                ->where('phase', 'Submitted')->where('sequence', 5)->first()->id,
            ]);
            $this->emit('refresh_ArSysStudentResearchPage');
            $this->emit('refreshApproval_ArSysComponentsResearchApproval');
            $this->emit('refreshInformation_ArSysComponentsResearchInformation');

        }
    }
}

