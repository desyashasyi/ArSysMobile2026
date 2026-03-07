<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\Event;
use App\Models\ArSys\FinalDefenseRoom;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class FinalDefenseRooms extends Component
{
    public $eventId;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    use LivewireAlert;
    public $event;
    protected $listeners=['refresh_SpecializationComponentsRoom' => '$refresh'];
    public function render()
    {
        $rooms = FinalDefenseRoom::where('event_id', $this->eventId)
            ->paginate($perPage = 1, $columns = ['*'], $pageName = 'finalDefenseRoom');
            //->paginate(1);

        return view('livewire.specialization.event.components.final-defense-rooms',[
            'rooms' => $rooms
        ]);
    }

    public function mount($eventId){
        $this->counter = 0;
        $this->event = Event::find($eventId);
        $this->eventId = $eventId;
    }
    public function addRoom(){
        FinalDefenseRoom::create([
            'event_id' => $this->eventId,
        ]);
        $this->emit('refreshView_ArSysSpecializationEventApplicant_Finaldefense');
    }

    public function deleteRoom($roomId){
        if(FinalDefenseRoom::find($roomId)->examiner->isEmpty() && FinalDefenseRoom::find($roomId)->applicant->isEmpty()){
            FinalDefenseRoom::find($roomId)->delete();
            $this->emit('refreshView_ArSysSpecializationEventApplicant_Finaldefense');
            $this->render();
        }else{
            $this->alert('info', 'There is at least one applicant or examiner assigned to this room',[
                'position' => 'top',
            ]);
        }
    }
}
