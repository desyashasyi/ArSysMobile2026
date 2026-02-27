<?php

namespace App\Http\Livewire\Staff\Event\Components;

use Livewire\Component;
use App\Models\ArSys\DefenseScoreGuide;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\FinalDefenseSupervisorPresence;
use App\Models\ArSys\Event;
use Jantinnerezo\LivewireAlert\LivewireAlert;

class SeminarScoreSupervisor extends Component
{
    protected $listeners = ['score_ArSysStaffSupervisor_Seminar'];
    public $scoreGuide;
    public $supervisor;
    public $finaldefenseRemark;
    public $finaldefenseScore;
    public $supervisorId;
    public $event;
    public $eventId;
    use LivewireAlert;
    public function render()
    {
        $this->scoreGuide = DefenseScoreGuide::orderBy('sequence', 'ASC')->get();
        $this->supervisor = ResearchSupervisor::find($this->supervisorId);
        $this->event = Event::find($this->eventId);
        return view('livewire.staff.event.components.seminar-score-supervisor');
    }

    public function score_ArSysStaffSupervisor_Seminar($supervisorId, $eventId){
        $this->supervisorId = $supervisorId;
        $this->eventId = $eventId;
        $this->supervisor = ResearchSupervisor::find($supervisorId);
        $this->finaldefenseScore = $this->supervisor->finaldefenseSupervisorPresence->score;
        $this->finaldefenseRemark = $this->supervisor->finaldefenseSupervisorPresence->remark;
        $this->emit('set_ArSysStaffSupervisorScoreModal_Seminar');
    }

    public function submitFinalDefenseScore(){
        $this->validate([
            'finaldefenseScore' =>'required|digits:3',
        ]);
        if($this->finaldefenseScore != 0 && $this->finaldefenseScore <= 400){
            FinalDefenseSupervisorPresence::where('research_supervisor_id', $this->supervisorId)->update([
                'score' => $this->finaldefenseScore,
                'remark' => $this->finaldefenseRemark,
            ]);
            $this->alert('success', 'The student\'s final defense score has been submited/updated',[
                'position' => 'center',
            ]);
        }else{
            $this->alert('warning', 'The score value should be between 1-400',
            [
                'position' => 'center',
            ]);
        }
        $this->emit('refresh_StaffFinalDefensePage_Supervisor');
    }
}
