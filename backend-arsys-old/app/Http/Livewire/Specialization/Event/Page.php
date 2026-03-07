<?php

namespace App\Http\Livewire\Specialization\Event;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Program;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    use WithPagination;
    public $eventTypes;
    public $eventTypePage;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageNumber = null;
    public $viewEvent = false;
    public $programId;
    protected $listeners = ['refreshEventPage_SpecializationEventPage' => '$refresh', 'refreshPage'];
    public function render()
    {
        $this->eventTypes = EventType::orderBy('description', 'ASC')->get();
        $events = collect();
        if($this->eventTypePage){
            $this->programId = null;
            //dd(Auth::user()->sso);
            if(strlen(Auth::user()->sso) == 4 ){
                $this->programId = Auth::user()->sysrole->program_id;
            }elseif(strlen(Auth::user()->sso) > 7){
                $this->programId = Auth::user()->staff->program_id;
            }else{
                $this->programId = Auth::user()->student->program_id;
            }
            if(Program::find($this->programId)->cluster && ($this->eventTypePage !=  EventType::where('code', 'PRE')->first()->id)){
                $events = Event::whereHas('program', function($query){
                        $query->whereHas('cluster', function($query){
                            $query->where('cluster_base_id', Program::find($this->programId)->cluster->cluster_base_id);
                        });
                    })

                    ->where('event_type_id', EventType::where('id', $this->eventTypePage)->first()->id)
                    ->orderBy('event_date', 'DESC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'eventDatePage');
            }else{
                $events = Event::where('program_id', $this->programId)
                    ->where('event_type_id', EventType::where('id', $this->eventTypePage)->first()->id)
                    ->orderBy('event_date', 'DESC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'eventDatePage');
            }
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
        }
        return view('livewire.specialization.event.page', ['events' => $events]);
    }
    public function hydrate(){
        $this->emit('reloadSelectEventTypePage');
    }

    public function expandView($viewIndex, $eventId){
        $this->viewEvent = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        //$this->emit('viewEvent_ArSysSpecializationEventPage', $eventId);
    }
    public function delete($eventId){
        if(is_null(Event::where('id',$eventId)->first()->applicant)){
            Event::find($eventId)->delete();
        }
        $this->render();
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
}
