<?php

namespace App\Http\Livewire\Staff\Research\Components;

use App\Models\ArSys\ResearchSupervise;
use App\Models\ArSys\ResearchSuperviseDiscussion;
use Auth;
use Livewire\Component;

class SuperviseMeetingShow extends Component
{
    public $supervise;
    public $message;
    public $superviseMeetingId;
    protected $listeners= ['superviseMeetingShow_ArSysStaffResearchSuperviseMeeting'];
    public function render()
    {
        if($this->superviseMeetingId){
            $this->supervise = ResearchSupervise::find($this->superviseMeetingId);
        }

        return view('livewire.staff.research.components.supervise-meeting-show');
    }

    public function mount(){
        $this->supervise = null;
    }

    public function superviseMeetingShow_ArSysStaffResearchSuperviseMeeting($superviseMeetingId){
        $this->superviseMeetingId = $superviseMeetingId;
        $this->emit('superviseMeetingModal_ArSysStaffResearchSuperviseMeeting');
    }

    public function save(){
        ResearchSuperviseDiscussion::create([
            'supervise_id' => $this->supervise->id,
            'discussant_id' => Auth::user()->id,
            'message' => str_replace('<p>', '<p style="margin:0">', $this->message),
        ]);
        $this->message = '';
        $this->emit('setSummernoteMessageStaffSuperviseMeeting');
    }
    public function delete($discussionId){
        ResearchSuperviseDiscussion::find($discussionId)->delete();
    }
}
