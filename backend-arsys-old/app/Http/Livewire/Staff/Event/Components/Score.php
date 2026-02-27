<?php

namespace App\Http\Livewire\Staff\Event\Components;

use Livewire\Component;
use App\Models\ArSys\DefenseScoreGuide;
use App\Models\ArSys\DefenseExaminer;
use App\Models\ArSys\DefenseExaminerPresence;
use Jantinnerezo\LivewireAlert\LivewireAlert;
class Score extends Component
{
    protected $listeners = ['score_ArSysStaffExaminer'];
    public $scoreGuide;
    public $examiner;
    public $remark;
    public $defenseScore;
    public $examinerId;
    use LivewireAlert;
    public function render()
    {
        $this->examiner = DefenseExaminer::find($this->examinerId);
        $this->scoreGuide = DefenseScoreGuide::orderBy('sequence', 'ASC')->get();
        return view('livewire.staff.event.components.score');
    }

    public function score_ArSysStaffExaminer($examinerId){
        $this->examinerId = $examinerId;
        $this->examiner = DefenseExaminer::find($this->examinerId);
        $this->defenseScore = $this->examiner->defenseExaminerPresence->score;
        $this->remark = $this->examiner->defenseExaminerPresence->remark;
        $this->emit('set_ArSysStaffExaminerScoreModal');
    }

    public function submitDefenseScore(){
        $this->validate([
            'defenseScore' =>'required|digits:3',
        ]);
        if($this->defenseScore != 0 && $this->defenseScore <= 400){
            DefenseExaminerPresence::where('defense_examiner_id', $this->examinerId)->update([
                'score' => $this->defenseScore,
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
        $this->emit('refresh_ArSysStaffEventDefense');
    }
}
