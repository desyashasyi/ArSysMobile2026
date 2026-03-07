<?php

namespace App\Http\Livewire\Staff\Event\Components;

use Livewire\Component;
use App\Models\ArSys\DefenseScoreGuide;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\DefenseSupervisorPresence;
use App\Models\ArSys\Event;
use Jantinnerezo\LivewireAlert\LivewireAlert;

class ScoreSupervisor extends Component
{
    protected $listeners = ['score_ArSysStaffSupervisor'];
    public $scoreGuide;
    public $supervisor;
    public $defenseremark;
    public $defenseScore;
    public $supervisorId;
    public $event;
    public $eventId;
    use LivewireAlert;
    public function render()
    {
        $this->scoreGuide = DefenseScoreGuide::orderBy('sequence', 'ASC')->get();
        $this->supervisor = ResearchSupervisor::find($this->supervisorId);
        $this->event = Event::find($this->eventId);
        return view('livewire.staff.event.components.score-supervisor');
    }

    public function score_ArSysStaffSupervisor($supervisorId, $eventId){
        $this->supervisorId = $supervisorId;
        $this->eventId = $eventId;
        $this->supervisor = ResearchSupervisor::find($supervisorId);
        $this->defenseScore = $this->supervisor->defenseSupervisorPresence->score;
        $this->defenseremark = $this->supervisor->defenseSupervisorPresence->remark;
        $this->emit('set_ArSysStaffSupervisorScoreModal');
    }

    public function submitDefenseScore(){
        $this->validate([
            'defenseScore' =>'required|digits:3',
        ]);
        if($this->defenseScore != 0 && $this->defenseScore <= 400){
            DefenseSupervisorPresence::where('research_supervisor_id', $this->supervisorId)->update([
                'score' => $this->defenseScore,
                'remark' => $this->defenseremark,
            ]);
            $this->alert('success', 'The student\'s defense score has been submited/updated',[
                'position' => 'center',
            ]);
        }else{
            $this->alert('warning', 'The score value should be between 1-400',
            [
                'position' => 'center',
            ]);
        }
        $this->emit('refresh_ArSysStaffEventDefense');
    }
}
