<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\EventSession;
use App\Models\ArSys\FinalDefenseRoom;
use App\Models\ArSys\SeminarRoom;
use Livewire\Component;
use Livewire\WithPagination;

class Session extends Component
{
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $applicantId;
    public $finalDefenseId;
    public $seminarId;

    public $applicant;
    public $room;
    public $sessionId;
    protected $listeners = ['session_ArSysSpecializationEventApplicant'];
    public function render()
    {
        $sessions = collect();
        if($this->applicantId){
            $this->applicant = EventApplicantDefense::find($this->applicantId);
            $sessions = EventSession::where('examination_type', EventApplicantDefense::find($this->applicantId)->event->type->examination_type)
                        ->paginate($perPage = 5, $columns = ['*'], $pageName = 'Session');
        }
        if($this->finalDefenseId){
            $this->room = FinalDefenseRoom::find($this->finalDefenseId);
            $sessions = EventSession::where('examination_type', FinalDefenseRoom::find($this->finalDefenseId)->event->type->examination_type)
                        ->paginate($perPage = 5, $columns = ['*'], $pageName = 'Session');
        }
        if($this->seminarId){
            $this->room = SeminarRoom::find($this->seminarId);
            $sessions = EventSession::where('examination_type', SeminarRoom::find($this->seminarId)->event->type->examination_type)
                        ->paginate($perPage = 5, $columns = ['*'], $pageName = 'Session');
        }

        return view('livewire.specialization.event.components.session',['sessions' => $sessions]);
    }

    public function session_ArSysSpecializationEventApplicant($id, $mode){
        if($mode == 'Defense'){
            $this->applicantId = $id;
        }
        if($mode == 'Final-defense'){
            $this->finalDefenseId = $id;
        }
        if($mode == 'Seminar'){
            $this->seminarId = $id;
        }
        $this->mode = $mode;


        $this->emit('set_ArSysSpecializationEventSessionModal');

    }

    public function sessionSelect($sessionId){
        $this->sessionId = $sessionId;
        if($this->mode == 'Defense'){
            EventApplicantDefense::find($this->applicantId)->update([
                'session_id' => $sessionId,
            ]);
        }
        if($this->mode == 'Final-defense'){
            FinalDefenseRoom::find($this->finalDefenseId)->update([
                'session_id' => $sessionId,
            ]);
        }
        if($this->mode == 'Seminar'){
            SeminarRoom::find($this->seminarId)->update([
                'session_id' => $sessionId,
            ]);
        }

        $this->emit('refresh_SpecializationComponentsRoom');
        $this->emit('refresh_ArSysSpecializationEventApplicant');
    }

}
