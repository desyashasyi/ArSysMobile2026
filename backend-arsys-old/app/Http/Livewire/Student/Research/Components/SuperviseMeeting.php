<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchSupervise;
use Auth;
use carbon\Carbon;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class SuperviseMeeting extends Component
{
    use LivewireAlert;
    public $research;
    public $supervisor;
    public $supervisors;
    public $message;
    public $dateOfMeeting;
    public $topic;
    public $researchId;
    protected $listeners = ['superviseMeeting_ArSysStudentResearchSuperviseMeeting' => 'createSuperviseMeeting'];
    public function render()
    {
        return view('livewire.student.research.components.supervise-meeting');
    }

    public function mount(){
        $this->supervisors = collect();
    }
    public function hydrate(){
        $this->emit('reloadSelecSupervisorSuperviseMeeting');
    }
    public function createSuperviseMeeting($researchId){
        dd('here');
        $this->researchId = $researchId;
        $this->dateOfMeeting = Carbon::parse(Carbon::now()->format('d F Y'));
        $this->supervisors = Research::find($researchId)->supervisor;
        $this->emit('superviseMeetingModal_ArSysStudentResearchSuperviseMeeting');
    }

    public function save(){
        $researchSupervise = ResearchSupervise::where('research_id', $this->researchId)
            ->where('supervisor_id',$this->supervisor)->latest()->first();
        if(!is_null($researchSupervise)){
            if(Carbon::parse($researchSupervise->created_at)->diffInDays(Carbon::now()) > 7){
                $this->validate([
                    'message' => 'required',
                    'dateOfMeeting' => 'required',
                    'supervisor' => 'required',
                    'topic' =>'required',
                ]);

                ResearchSupervise::create([
                    'message' => $this->message,
                    //'date_of_meeting' => Carbon::parse($this->dateOfMeeting)->format('d F Y'),
                    'supervisor_id' => $this->supervisor,
                    'topic' => $this->topic,
                    'research_id' => $this->researchId,
                    'threader_id' => Auth::user()->id,
                ]);
                $this->emit('refresh_ArSysStudentResearchPageSupervise');
                $this->emit('refresh_ArSysStudentResearchPage');
            }else{
                $this->alert('error', 'The meeting report should be at least 7 days after the last meeting',[
                    'position' => 'center',
                ]);
            }

        }else{
            $this->validate([
                'message' => 'required',
                'dateOfMeeting' => 'required',
                'supervisor' => 'required',
                'topic' =>'required',
            ]);

            ResearchSupervise::create([
                'message' => $this->message,
                //'date_of_meeting' => Carbon::parse($this->dateOfMeeting)->format('d F Y'),
                'supervisor_id' => $this->supervisor,
                'topic' => $this->topic,
                'research_id' => $this->researchId,
                'threader_id' => Auth::user()->id,
            ]);
            $this->alert('success', 'Yes',[
                'position' => 'top-center',
            ]);
        }
        $this->emit('resetSummernoteMessageStudentSuperviseMeeting');
    }
    public function close(){
        $this->emit('refresh_ArSysStudentResearchPageSupervise');
        $this->emit('refresh_ArSysStudentResearchPage');
    }
}
