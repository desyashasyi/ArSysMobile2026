<?php

namespace App\Http\Livewire\Specialization\Event\Defense;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $eventTypes;
    public $eventTypePage;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageName = 'researchPage';
    public $pageNumber = null;
    public $viewEvent = false;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    protected $listeners = ['refresh_SpecializationEventApplicantPage' => '$refresh', 'refreshPage'];
    public function render()
    {
        $events = collect();
        $programId = null;
        if(strlen(Auth::user()->sso) == 4 ){
            $programId = Auth::user()->sysrole->program_id;
        }elseif(strlen(Auth::user()->sso) > 7){
            $programId = Auth::user()->staff->program_id;
        }else{
            $programId = Auth::user()->student->program_id;
        }

        if(!is_null(Auth::user()->staff->program->cluster)){
            $events = Event::whereHas('program', function($query){
                $query->whereHas('cluster', function($query){
                    $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
                });
            })
            ->where('event_type_id', EventType::where('examination_type', 'Defense')->where('code', 'PRE')->first()->id)
            ->whereHas('defenseApplicant')
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'eventDatePage');
        }else{
            $events = Event::where('program_id', $programId)
            ->where('event_type_id', EventType::where('examination_type', 'Defense')->where('code', 'PRE')->first()->id)
            ->whereHas('defenseApplicant')
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'eventDatePage');
        }

        /*$events = Event::where('program_id', $programId)
            ->where('event_type_id', EventType::where('examination_type', 'Defense')->where('code', 'PRE')->first()->id)
            ->whereHas('defenseApplicant')
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'eventDatePage');
            //
        */
        if($this->pageNumber != $events->currentPage()){
            foreach($events as $index => $event){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $events->currentPage();
            $this->tempIndex = $events->count()+1;
            $this->viewIndex = $events->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewEvent == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }

        return view('livewire.specialization.event.defense.page', ['events' => $events]);
    }
    public function expandView($viewIndex, $eventId){
        $this->viewEvent = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        //$this->emit('viewEvent_ArSysSpecializationEventPage', $eventId);
    }
    public function delete($eventId){
        if(Event::where('id',$eventId)->first()->applicant->isEmpty()){
            Event::find($eventId)->delete();
        }
    }

    public function refreshPage(){
        $this->viewEvent = false;
        $this->render();
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }

    public function publishEvent($eventId){
        Event::find($eventId)->update([
            'status' => 1,
        ]);
        foreach(Event::find($eventId)->defenseApplicant as $applicant){
            if(!is_null($applicant->space_id) && !is_null($applicant->session_id)
                && !is_null($applicant->space_id) && $applicant->defenseExaminer->isNotEmpty()){
                if(is_null(EventApplicantDefense::find($applicant->id)->publish)){
                    EventApplicantDefense::find($applicant->id)->update([
                        'publish' => 1,
                    ]);
                    Research::find($applicant->research_id)->update([
                        'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')
                                            ->where('phase', 'Scheduled')->first()->id,
                    ]);
                    if(is_null(Research::find($applicant->research_id)->DEFSCHEDULED)){
                        ResearchLog::create([
                            'research_id' => $applicant->research_id,
                            'type_id' =>  ResearchLogType::where('code', 'DEFSCHEDULED')->first()->id,
                            'loger_id' => Auth::user()->id,
                            'message' => ResearchLogType::where('code', 'DEFSCHEDULED')->first()->description,
                            'status' => 1,
                        ]);
                    }
                }
            }
        }
        $this->emit('refresh_ArSysSpecializationEventApplicant');
    }
}
