<?php

namespace App\Http\Livewire\Staff\Event\Components;

use Livewire\Component;
use App\Models\ArSys\DefenseScoreGuide;
use App\Models\ArSys\FinalDefenseExaminer;
use App\Models\ArSys\FinalDefenseExaminerPresence;
use App\Models\ArSys\Research;
use Jantinnerezo\LivewireAlert\LivewireAlert;
class SeminarScore extends Component
{
    protected $listeners = ['seminarScore_ArSysStaffExaminer'];
    public $scoreGuide;
    public $examiner;
    public $remark;
    public $score;
    public $presenceId;
    use LivewireAlert;
    public $presence;
    public function render()
    {
        if($this->presenceId){
            $this->presence = FinalDefenseExaminerPresence::find($this->presenceId);
        }
        $this->scoreGuide = DefenseScoreGuide::orderBy('sequence', 'ASC')->get();
        return view('livewire.staff.event.components.seminar-score');
    }

    public function seminarScore_ArSysStaffExaminer($presenceId){
        $this->presenceId = $presenceId;
        $this->presence = FinalDefenseExaminerPresence::find($this->presenceId);
        $this->score = $this->presence->score;
        $this->remark = $this->presence->remark;
        $this->emit('set_ArSysstaffSeminarScoreModal');
    }

    public function submitSeminarScore(){
        $this->validate([
            'score' =>'required|digits:3',
        ]);
        if($this->score != 0 && $this->score <= 400){
            FinalDefenseExaminerPresence::where('id', $this->presenceId)->update([
                'score' => $this->score,
                'remark' => $this->remark,
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
        $this->emit('refresh_StaffFinalDefensePage');
    }
}
