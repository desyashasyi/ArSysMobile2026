<?php

namespace App\Http\Livewire\Specialization\Event\FinalDefense\Components;

use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\EventApplicantFinalDefense;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Livewire\Component;

class ApplicantAdd extends Component
{
    public $finalDefenseAdd = null;
    public $eventId;
    public function render()
    {
        $unApplyApplicants = collect();
        $unApplyApplicants = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('finaldefenseAExtra')
        ->whereHas('milestone', function($query){
            $query->where('id', 12);
        })
        ->paginate($perPage = 3, $columns = ['*'], $pageName = 'unApplyApplicant');
        //->get();
        return view('livewire.specialization.event.final-defense.components.applicant-add', ['unApplyApplicants' => $unApplyApplicants]);
    }

    public function mount($eventId){
        $this->eventId = $eventId;
    }
    public function enableAddApplicant(){
        if(is_null($this->finalDefenseAdd)){
            $this->finalDefenseAdd = 1;
        }else{
            $this->finalDefenseAdd = null;
        }
    }

    public function addParticipant($researchId){

        if(!is_null(Research::find($researchId)->finaldefenseApplied)){
            EventApplicantFinalDefense::find(Research::find($researchId)->finaldefenseApplied->id)
            ->update([
                'event_id' => $this->eventId,
            ]);
        }else{
            EventApplicantFinalDefense::create([
                'event_id' => $this->eventId,
                'research_id' => $researchId,
                'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
            ]);
        }

        Research::find($researchId)->update([
            'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                ->where('phase', 'Applied')->first()->id,
        ]);
        if(is_null(Research::find($researchId)->PUBAPPLIED)){
            ResearchLog::create([
                'research_id' =>  $researchId,
                'type_id' =>  ResearchLogType::where('code', 'PUBAPPLIED')->first()->id,
                'loger_id' => Auth::user()->id,
                'message' => ResearchLogType::where('code', 'PUBAPPLIED')->first()->description,
                'status' => 1,
            ]);
        }
        $this->emit('refreshView_ArSysSpecializationEventApplicant_FinalDefense');
        $this->emit('refreshPage_ArSysSpecializationEventApplicant_FinalDefense');
    }
}
