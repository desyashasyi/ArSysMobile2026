<?php

namespace App\Http\Livewire\Components\Research;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\Research;
use Livewire\Component;
use Livewire\WithPagination;

class AppliedEvent extends Component
{
    public $research;
    public $researchId;
    public $eventId;
    public $event;

    protected $listeners = ['refresh_ArSysComponentsResearchAppliedEvent' => '$refresh'];
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $this->research = Research::find($this->researchId);

        $applicants = null;
        if($this->eventId){
            $this->event = Event::find($this->eventId);
            //dd(EventApplicantDefense::where('event_id', $this->eventId));
            $applicants = EventApplicantDefense::where('event_id', $this->eventId)
            ->orderBy('session_id', 'ASC')
            ->paginate($perPage = 15, $columns = ['*'], $pageName = 'eventApplicant');
        }

        return view('livewire.components.research.applied-event', ['applicants' => $applicants]);
    }
    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function showAppliedEvent($eventId){
        $this->eventId = $eventId;
        $this->emit('arsysComponentsResearchAppliedEvent');
    }
}
