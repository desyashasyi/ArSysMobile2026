<?php

namespace App\Http\Livewire\Staff\Event\FinalDefense;

use Livewire\Component;
use App\Models\ArSys\EventApplicantFinaldefense;
use Auth;
class Supervisor extends Component
{
    public $eventId;
    public $applicants;
    protected $listeners = ['refresh_StaffFinalDefensePage_Supervisor' => '$refresh'];
    public function render()
    {
        if(!is_null($this->eventId)){
            $this->applicants = EventApplicantFinaldefense::where('event_id', $this->eventId)
                ->whereHas('research', function($query){
                    $query->whereHas('supervisor', function($query){
                        $query->where('supervisor_Id', Auth::user()->staff->id);
                    });
                })
                ->get();
        }
        return view('livewire.staff.event.final-defense.supervisor');
    }
    public function mount($eventId){
        $this->eventId = $eventId;
    }
}
