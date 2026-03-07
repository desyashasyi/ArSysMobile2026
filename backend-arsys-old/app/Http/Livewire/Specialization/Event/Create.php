<?php

namespace App\Http\Livewire\Specialization\Event;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventType;
use Auth;
use Carbon\Carbon;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Create extends Component
{
    public $addEvent;
    public $eventTypes;
    public $eventTypeCreate;
    public $dateOfEvent;
    public $applicationDeadline;
    public $draftDeadline;
    public $quota;
    use LivewireAlert;
    public function render()
    {
        $this->eventTypes = EventType::all();
        return view('livewire.specialization.event.create');
    }


    public function mount(){
        $this->dateOfEvent = Carbon::now();
        $this->applicationDeadline = Carbon::now();
        $this->draftDeadline = Carbon::now();

    }
    public function hydrate(){
        $this->emit('reloadSelectEventType');
    }
    public function addEvent(){
        if($this->addEvent ==  1){
            $this->addEvent = 0;
        }else{
            $this->addEvent = 1;
            $this->emit('refreshPage');
        }
    }

    protected $rules = [
        'dateOfEvent' => 'required',
        'applicationDeadline' => 'required',
        'draftDeadline' => 'required',
        'quota' => 'required',
    ];

    protected $message = [
        'dateOfEvent' => 'The date of event is required',
        'applicationDeadline' => 'The application deadline is required',
        'draftDeadline' => 'The draft deadline is required',
        'quota' => 'The participant quota is required',
    ];
    public function save()
    {
        $this->validate();
        $hasCluster = null;
        $checkEvent = null;
        $hasCluster = Auth::user()->staff->program->cluster;
        if($hasCluster){
            //dd($this->eventTypeCreate, EventType::where('code','PRE')->first()->id);
            if($this->eventTypeCreate != EventType::where('code','PRE')->first()->id){
                //dd(Carbon::parse($this->dateOfEvent)->format('Y-m-d'));
                $checkEvent = Event::whereHas('program', function($query){
                        $query->whereHas('cluster', function($query){
                            $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
                        });
                    })
                    ->whereDate('event_date', '=', Carbon::parse($this->dateOfEvent)->format('Y-m-d'))
                    ->where('event_type_id',$this->eventTypeCreate)->first();
                    //dd($checkEvent);
            }

        }
        $checkEvent = null;
        if($checkEvent){
            $this->alert('warning', 'There is an event that has same event date.',[
                'position' => 'center',
            ]);
        }else{
            Event::create([
                'program_id' => Auth::user()->staff->program_id,
                'event_type_id' => $this->eventTypeCreate,
                'event_date' => $this->dateOfEvent,
                'application_deadline' => $this->applicationDeadline,
                'draft_deadline' => $this->draftDeadline,
                'quota' => $this->quota,

            ]);
            $this->eventTypeCreate = null;
            $this->dateOfEvent = null;
            $this->applicationDeadline = null;
            $this->draftDeadline = null;
            $this->quota = null;
            $this->emit('refreshPage');
        }
        $this->emit('refreshEventPage_SpecializationEventPage');
    }
}
