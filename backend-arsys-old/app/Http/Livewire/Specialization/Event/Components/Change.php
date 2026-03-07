<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventApplicantFinalDefense;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Carbon\Carbon;
use Livewire\Component;
use Livewire\WithPagination;

class Change extends Component
{
    protected $listeners = ['change_ArSysSpecializationEvent'];
    public $applicantId;
    public $eventTypeId;
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $research;
    public function render()
    {
        $events = collect();
        if($this->applicantId){
            $this->research = EventApplicantDefense::find($this->applicantId)->research;

            $hasCluster = null;
            $hasCluster = Auth::user()->staff->program->cluster;
            if($hasCluster && ($this->eventTypeId != EventType::where('code', 'PRE')->first()->id)) {
                $events =  Event::whereHas('program', function($query){
                    $query->whereHas('cluster', function($query){
                        $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
                    });
                })
                ->whereHas('type',function($query){
                    $query->where('defense_model_id', $this->research->milestone->defense_model_id);
                })
                ->where('event_date', '>=', Carbon::now())
                ->orderBy('event_date', 'DESC')
                ->paginate($perPage = 10, $columns = ['*'], $pageName = 'specializationEventChange');
            }else{
                $events = Event::where('program_id', Auth::user()->staff->program_id)
                ->whereHas('type',function($query){
                    $query->where('defense_model_id', $this->research->milestone->defense_model_id);
                })
                ->where('event_date', '>=', Carbon::now())
                ->orderBy('event_date', 'DESC')
                ->paginate($perPage = 10, $columns = ['*'], $pageName = 'specializationEventChange');
            }

        }
        return view('livewire.specialization.event.components.change', ['events' => $events]);
    }

    public function change_ArSysSpecializationEvent($applicantId, $eventTypeId){
        $this->applicantId = $applicantId;
        $this->eventTypeId = $eventTypeId;
        $this->emit('change_SpecializationEventChangeModal');
    }

    public function apply($eventId){
        if(Event::find($eventId)->type->examination_type ==
            EventApplicantDefense::find($this->applicantId)->event->type->examination_type){
            if(!is_null($this->research->predefenseApplied)){
                EventApplicantDefense::find($this->research->predefenseApplied->id)
                ->update([
                    'event_id' => $eventId,
                ]);
            }else{
                EventApplicantDefense::create([
                    'event_id' => $eventId,
                    'research_id' => $this->research->id,
                    'defense_model_id' => DefenseModel::where('code', 'PRE')->first()->id,
                ]);
            }
            Research::find($this->research->id)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')
                                    ->where('phase', 'Applied')->first()->id,
            ]);
            EventApplicantDefense::where('event_id', $eventId)->where('research_id',$this->research->id)->update([
                'publish' => NULL,
            ]);
            $this->emit('refresh_SpecializationEventApplicantPage');
            $this->emit('refresh_ArSysSpecializationEventApplicant');
        }
        if(Event::find($eventId)->type->examination_type ==
            EventApplicantFinalDefense::find($this->applicantId)->event->type->examination_type){
            if(!is_null($this->research->finaldefenseApplied)){
                EventApplicantFinalDefense::find($this->research->finaldefenseApplied->id)
                ->update([
                    'event_id' => $eventId,
                ]);
            }else{
                EventApplicantFinalDefense::create([
                    'event_id' => $eventId,
                    'research_id' => $this->research->id,
                    'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                ]);
            }
            Research::find($this->research->id)->update([
                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                    ->where('phase', 'Applied')->first()->id,
            ]);
            EventApplicantFinalDefense::where('event_id', $eventId)->where('research_id',$this->research->id)->update([
                'publish' => NULL,
            ]);
            $this->emit('refresh_ArSysSpecializationEventApplicant');
            $this->emit('refresh_SpecializationEventApplicantPage_Seminar');

        }
    }
}
