<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventApplicantFinalDefense;
use App\Models\ArSys\EventApplicantSeminar;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Carbon\Carbon;
use Livewire\Component;
use Livewire\WithPagination;

class ApplyEvent extends Component
{
    public $researchId;
    public $research;
    use WithPagination;
    public $milestone;
    protected $paginationTheme = 'bootstrap';
    protected $listeners = ['applyEvent_StudentResearchAction'];
    public function render()
    {
        $this->research = Research::find($this->researchId);
        $events = null;
        if($this->research){
            if((Auth::user()->student->program->cluster) &&
                ($this->research->milestone->defense_model_id != EventType::where('code', 'PRE')->first()->defense_model_id)) {
                /*$events = Event::whereHas('program', function($query){
                    $query->whereHas('cluster', function($query){
                       $query->where('cluster_base_id', Auth::user()->student->program->cluster->cluster_base_id);
                    });
                })
                */
                $events = Event::where('program_id', Auth::user()->student->program_id)
                ->whereHas('type',function($query){
                    $query->where('defense_model_id', $this->research->milestone->defense_model_id);
                })
                ->where('application_deadline', '>', Carbon::now())
                ->orderBy('application_deadline', 'DESC')
                ->paginate($perPage = 10, $columns = ['*'], $pageName = 'studentEventApply');
            }else{
                $events = Event::where('program_id', Auth::user()->student->program_id)
                ->whereHas('type',function($query){
                    $query->where('defense_model_id', $this->research->milestone->defense_model_id);
                })
                ->where('application_deadline', '>', Carbon::now())
                ->orderBy('application_deadline', 'DESC')
                ->paginate($perPage = 10, $columns = ['*'], $pageName = 'studentEventApply');
            }


        }
        return view('livewire.student.research.components.apply-event', ['events' => $events]);
    }

    public function applyEvent_StudentResearchAction($researchId){
        $this->researchId = $researchId;
        $this->emit('studentEventApplyModal');
    }

    public function apply($eventId){
        $event = Event::find($eventId);
        if($event->type->examination_type == 'Defense' ){
            if(!is_null($this->research->predefenseApplied)){
                EventApplicantDefense::find($this->research->predefenseApplied->id)
                ->update([
                    'event_id' => $eventId,
                ]);
            }else{
                EventApplicantDefense::create([
                    'event_id' => $eventId,
                    'research_id' => $this->researchId,
                    'defense_model_id' => DefenseModel::where('code', 'PRE')->first()->id,
                ]);
            }
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')
                                    ->where('phase', 'Applied')->first()->id,
            ]);
            if(is_null(Research::find($this->researchId)->DEFAPPLIED)){
                ResearchLog::create([
                    'research_id' =>  $this->researchId,
                    'type_id' =>  ResearchLogType::where('code', 'DEFAPPLIED')->first()->id,
                    'loger_id' => Auth::user()->id,
                    'message' => ResearchLogType::where('code', 'DEFAPPLIED')->first()->description,
                    'status' => 1,
                ]);
            }


        }

        if($event->type->examination_type == 'Final-defense' ){
            if(!is_null($this->research->finaldefenseApplied)){
                EventApplicantFinalDefense::find($this->research->finaldefenseApplied->id)
                ->update([
                    'event_id' => $eventId,
                ]);
            }else{
                EventApplicantFinalDefense::create([
                    'event_id' => $eventId,
                    'research_id' => $this->researchId,
                    'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                ]);
            }
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                    ->where('phase', 'Applied')->first()->id,
            ]);
            if(is_null(Research::find($this->researchId)->PUBAPPLIED)){
                ResearchLog::create([
                    'research_id' =>  $this->researchId,
                    'type_id' =>  ResearchLogType::where('code', 'PUBAPPLIED')->first()->id,
                    'loger_id' => Auth::user()->id,
                    'message' => ResearchLogType::where('code', 'PUBAPPLIED')->first()->description,
                    'status' => 1,
                ]);
            }


        }

        if($event->type->examination_type == 'Seminar' ){
            if(!is_null($this->research->seminarApplied)){
                EventApplicantSeminar::find($this->research->seminarApplied->id)
                ->update([
                    'event_id' => $eventId,
                ]);
            }else{
                EventApplicantSeminar::create([
                    'event_id' => $eventId,
                    'research_id' => $this->researchId,
                    'defense_model_id' => DefenseModel::where('code', 'SEM')->first()->id,
                ]);
            }
            Research::find($this->researchId)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Seminar')
                                    ->where('phase', 'Applied')->first()->id,
            ]);
            if(is_null(Research::find($this->researchId)->SEMAPPLIED)){
                ResearchLog::create([
                    'research_id' =>  $this->researchId,
                    'type_id' =>  ResearchLogType::where('code', 'SEMAPPLIED')->first()->id,
                    'loger_id' => Auth::user()->id,
                    'message' => ResearchLogType::where('code', 'SEMAPPLIED')->first()->description,
                    'status' => 1,
                ]);
            }
        }
        $this->emit('refreshInformation_ArSysComponentsResearchInformation');
        $this->emit('refresh_ArSysStudentResearchPage');
        $this->emit('refresh_ArSysStudentResearchAction');
        $this->emit('refresh_ArSysComponentsResearchAppliedEvent');
    }
}
