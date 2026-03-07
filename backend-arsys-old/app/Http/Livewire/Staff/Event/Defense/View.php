<?php

namespace App\Http\Livewire\Staff\Event\Defense;

use Livewire\Component;
use App\Models\ArSys\Event;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\DefenseExaminer;
use App\Models\ArSys\DefenseExaminerPresence;
use App\Models\ArSys\DefenseSupervisorPresence;
use Livewire\WithPagination;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Auth;
class View extends Component
{
    public $eventId;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    use LivewireAlert;
    protected $listeners = ['refresh_ArSysStaffEventDefense' => '$refresh'];
    public function render()
    {
        $eventApplicants = null;
        $eventApplicants =  EventApplicantDefense::
            where('event_id', $this->eventId)
            ->whereHas('research', function($query){
                $query->whereHas('supervisor', function($query){
                    $query->where('supervisor_Id', Auth::user()->staff->id);
                });
            })
            ->orWhereHas('defenseExaminer', function($query){
                $query->where('examiner_id', Auth::user()->staff->id);
            })
            ->orderBy('session_id', 'ASC')
            ->get();
        return view('livewire.staff.event.defense.view', ['eventApplicants' => $eventApplicants]);
    }
    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function examinerPresence($examinerId, $applicantId){
        $research = Research::find(DefenseExaminer::find($examinerId)->defenseApplicant->research->id);
        $examinerPresence = DefenseExaminer::where('applicant_id', $applicantId)
            ->whereHas('defenseExaminerPresence')
            ->get();
        if(is_null(DefenseExaminer::find($examinerId)->defenseExaminerPresence)){
            if($examinerPresence->count() < 3){
                DefenseExaminerPresence::create([
                    'defense_examiner_id' => $examinerId,
                    'event_id' => DefenseExaminer::find($examinerId)->event_id,
                    'examiner_id' => DefenseExaminer::find($examinerId)->examiner_id,
                ]);
            }else{
                $this->alert('info', 'The maximum number of examiners has been reached',[
                    'position' => 'top',
                ]);
            }
        }else{
            DefenseExaminerPresence::where('defense_examiner_id', $examinerId)->delete();
        }

        //dd(DefenseExaminer::find($examinerId)->defenseApplicant->research->id);
        if($research->supervisor){
            foreach($research->supervisor as $supervisor){
                if(is_null($supervisor->defenseSupervisorPresence)){
                    DefenseSupervisorPresence::create([
                        'research_supervisor_id' => $supervisor->id,
                        'event_id' => DefenseExaminer::find($examinerId)->event_id,
                        'supervisor_id' => $supervisor->staff->id,
                        'research_id' => $supervisor->research->id,
                    ]);
                }

            }
            $research->update([
                'milestone_id' => ResearchMilestone::where('code', 'Pre-defense')
                                    ->where('phase', 'Done')->first()->id,
            ]);

            if(is_null($research->DEFDONE)){
                ResearchLog::create([
                    'research_id' => $research->id,
                    'type_id' =>  ResearchLogType::where('code', 'DEFDONE')->first()->id,
                    'loger_id' => Auth::user()->id,
                    'message' => ResearchLogType::where('code', 'DEFDONE')->first()->description,
                    'status' => 1,
                ]);
            }

            //dd(Research::find(DefenseExaminer::find($examinerId)->defenseApplicant->research->id)->supervisor);
        }
    }
    public function unAssign($examinerId){
        DefenseExaminer::find($examinerId)->delete();
        $this->emit('refresh_ArSysStaffEventDefense');
    }
}
