<?php

namespace App\Http\Livewire\Specialization\Event\Defense;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use Livewire\Component;
use Livewire\WithPagination;

class Schedule extends Component
{
    public $eventId;
    public $event;
    use WithPagination;
    public $applicantCount;
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        if($this->eventId){
            $this->event = Event::find($this->eventId);
            $applicants = EventApplicantDefense::where('event_id', $this->eventId)
            ->orderBy('session_id', 'ASC')
            ->get();
        }
        return view('livewire.specialization.event.defense.schedule', ['applicants' => $applicants]);

    }
    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function captureSchedule(){
        $this->applicantCount = 0;
        $this->emit('captureSchedule_SpecializationEventDefensePage');
    }
}
