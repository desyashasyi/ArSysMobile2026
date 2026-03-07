<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\ResearchSupervise;
use App\Models\ArSys\ResearchSuperviseDiscussion;
use Auth;
use Livewire\Component;

class SuperviseMeetingShow extends Component
{
    public $supervise;
    public $superviseMessage;
    public $superviseMeetingId;
    protected $listeners= ['superviseMeetingShow_ArSysStudentResearchSuperviseMeeting'];
    public function render()
    {
        if($this->superviseMeetingId){
            $this->supervise = ResearchSupervise::find($this->superviseMeetingId);
        }
        return view('livewire.student.research.components.supervise-meeting-show');
    }

    public function mount(){
        $this->supervise = null;
    }
    public function hydrate(){
        $this->emit('reloadSelecSupervisorSuperviseMeeting');
    }

    public function superviseMeetingShow_ArSysStudentResearchSuperviseMeeting($superviseMeetingId){
        $this->superviseMeetingId = $superviseMeetingId;
        $this->emit('superviseMeetingShowModal_ArSysStudentResearchSuperviseMeeting');
    }

    public function save(){
        ResearchSuperviseDiscussion::create([
            'supervise_id' => $this->supervise->id,
            'discussant_id' => Auth::user()->id,
            'message' => str_replace('<p>', '<p style="margin:0">', $this->superviseMessage),
        ]);
        $this->superviseMessage = '';
        $this->emit('setSummernoteMessageStudentSuperviseMeeting');
    }

    public function delete($discussionId){
        ResearchSuperviseDiscussion::find($discussionId)->delete();
    }
}
