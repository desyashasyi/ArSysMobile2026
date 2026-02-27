<?php

namespace App\Http\Livewire\Specialization\Event\Seminar;
use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantSeminar;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\SeminarSupervisorPresence;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
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
    use LivewireAlert;
    protected $listeners = ['refresh_SpecializationEventApplicantPage_Seminar' => '$refresh', 'refreshPage'];
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
            ->where('event_type_id', EventType::where('examination_type', 'Seminar')->where('code', 'SSP')->first()->id)
            ->whereHas('seminarApplicant')
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'eventDatePage');
        }else{
            $events = Event::where('program_id', $programId)
            ->where('event_type_id', EventType::where('examination_type', 'Seminar')->where('code', 'SSP')->first()->id)
            ->whereHas('seminarApplicant')
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'eventDatePage');
        }
            //
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
        return view('livewire.specialization.event.seminar.page', ['events' => $events]);
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
        if(!is_null(Event::find($eventId)->unsetSeminarRoom)){
            if(Event::find($eventId)->seminarApplicant->contains('room_id', null)){
                Event::find($eventId)->update([
                    'status' => null,
                ]);
                $this->alert('info', 'There is applicant without assigned room',[
                    'position' => 'top',
                ]);
            }else{
                Event::find($eventId)->update([
                    'status' => 1,
                ]);

                foreach(Event::find($eventId)->seminarApplicant as $applicant){
                    if(!is_null($applicant->room)){
                        if(is_null(EventApplicantSeminar::find($applicant->id)->publish)){
                            EventApplicantSeminar::find($applicant->id)->update([
                                'publish' => 1,
                            ]);
                            foreach($applicant->research->supervisor as $supervisor){

                                if(is_null(SeminarSupervisorPresence::
                                    where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
                                    ->where('event_id', $eventId)
                                    ->where('research_id', $applicant->research->id)
                                    ->where('research_supervisor_id', $supervisor->id)
                                    ->where('supervisor_id', $supervisor->staff->id)
                                    ->first()
                                )){
                                    SeminarSupervisorPresence::create([
                                        'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                                        'event_id' => $eventId,
                                        'research_id' => $applicant->research->id,
                                        'research_supervisor_id' => $supervisor->id,
                                        'supervisor_id' => $supervisor->staff->id,
                                    ]);
                                }
                            }

                            Research::find($applicant->research_id)->update([
                                'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                                                    ->where('phase', 'Scheduled')->first()->id,
                            ]);
                            if(is_null(Research::find($applicant->research_id)->PUBSCHEDULED)){
                                ResearchLog::create([
                                    'research_id' => $applicant->research_id,
                                    'type_id' =>  ResearchLogType::where('code', 'PUBSCHEDULED')->first()->id,
                                    'loger_id' => Auth::user()->id,
                                    'message' => ResearchLogType::where('code', 'PUBSCHEDULED')->first()->description,
                                    'status' => 1,
                                ]);
                            }
                            $this->emit('refreshView_ArSysSpecializationEventApplicant_Seminar');
                            $this->render();
                        }else{
                            /*EventApplicantSeminar::find($applicant->id)->update([
                                'publish' => NULL,
                            ]);
                            */
                        }
                    }
                }
            }


        }
        else{
            $this->alert('info', 'There is room without space, session, examiner or applicant',[
                'position' => 'top',
            ]);
        }
    }
}
