<?php

namespace App\Http\Livewire\Specialization\Event;

use App\Models\ArSys\Event;
use Livewire\Component;

class View extends Component
{
    public $dateOfEvent;
    public $applicationDeadline;
    public $draftDeadline;
    public $eventId;
    public $event;
    protected $listeners=['refreshEventView_SpecializationEventView' => '$refresh'];

    public function render()
    {
        $this->event = Event::find($this->eventId);
        return view('livewire.specialization.event.view');
    }

    public function mount($eventId){
        $this->eventId = $eventId;
        $this->emit('reloadEventView');
    }
    public function hydrate(){
        $this->emit('reloadEventView');
    }
}
