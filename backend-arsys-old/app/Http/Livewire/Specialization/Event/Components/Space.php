<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventSpace;
use App\Models\ArSys\FinalDefenseRoom;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class Space extends Component
{
    use WithPagination;
    use LivewireAlert;
    protected $paginationTheme = 'bootstrap';
    public $applicantId;
    public $roomId;
    public $mode;

    public $applicant;
    public $room;
    protected $listeners = ['space_ArSysSpecializationEventApplicant'];
    public function render()
    {
        $spaces = collect();
        if($this->applicantId){
            $this->applicant = EventApplicantDefense::find($this->applicantId);
            $spaces = EventSpace::paginate($perPage = 5, $columns = ['*'], $pageName = 'Spaces');
        }
        if($this->roomId){
            $this->room = FinalDefenseRoom::find($this->roomId);
            $spaces = EventSpace::paginate($perPage = 5, $columns = ['*'], $pageName = 'Spaces');
        }
        return view('livewire.specialization.event.components.space',['spaces' => $spaces]);
    }

    public function space_ArSysSpecializationEventApplicant($id, $mode){
        if($mode == 'Defense'){
            $this->applicantId = $id;
        }elseif($mode == 'Final-defense'){
            $this->roomId = $id;
        }elseif($mode == 'Seminar'){
            $this->roomId = $id;
        }
        $this->mode = $mode;

        $this->emit('set_ArSysSpecializationEventSpaceModal');

    }

    public function spaceSelect($spaceId){
        if($this->mode == 'Defense'){
            $checkSpace =  EventApplicantDefense::where('event_id', EventApplicantDefense::find($this->applicantId)->event_id)
                ->where('space_id', $spaceId)->where('session_id', EventApplicantDefense::find($this->applicantId)->session_id)->first();
            if(is_null($checkSpace)){
                EventApplicantDefense::find($this->applicantId)->update([
                    'space_id' => $spaceId,
                ]);
            }else{
                $this->alert('info', 'There is an event with the same space',[
                    'position' => 'top',
                ]);
            }
        }

        if($this->mode == 'Final-defense'){
            $checkSpace = FinalDefenseRoom::where('event_id', FinalDefenseRoom::find($this->roomId)->event_id)
                ->where('space_id', $spaceId)->first();
            if(is_null($checkSpace)){
                FinalDefenseRoom::find($this->roomId)->update([
                    'space_id' => $spaceId,
                ]);
            }else{
                $this->alert('info', 'There is an event with the same space',[
                    'position' => 'top',
                ]);
            }

        }

        $this->emit('refresh_ArSysSpecializationEventApplicant');
        $this->emit('refresh_SpecializationComponentsRoom');
    }

}
