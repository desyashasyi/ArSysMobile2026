<?php

namespace App\Http\Livewire\Specialization\Event\Defense;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventType;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class OthersDefense extends Component
{
    public $eventId;
    public $otherEventId;
    public $event;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    public function render()
    {

        $clusterEvents = Event::whereHas('program', function($query){
            $query->whereHas('cluster', function($query){
                    $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
                });
            })
            ->where('program_id', '!=', Auth::user()->staff->program_id)
            ->where('event_type_id', EventType::where('examination_type', 'Defense')->first()->id)
            ->whereHas('defenseApplicant')
            ->where('event_date', Event::find($this->eventId)->event_date)
            ->get();
            $eventApplicants = collect();
        if($this->otherEventId){
            $this->event = Event::find($this->otherEventId);
            $eventApplicants = EventApplicantDefense::where('event_id', $this->otherEventId)
                ->orderBy('session_id', 'ASC')
                //->get();
                ->get();
        }
        return view('livewire.specialization.event.defense.others-defense',
        [
            'clusterEvents' => $clusterEvents,
            'eventApplicants' => $eventApplicants,
        ]);
    }

    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function viewEventApplicant($eventId){
        $this->otherEventId = $eventId;
        $this->emit('otherEvent_SpecializationEventDefensePage');

    }
}
