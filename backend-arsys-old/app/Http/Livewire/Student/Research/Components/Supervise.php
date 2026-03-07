<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\Research;
use Livewire\Component;

class Supervise extends Component
{
    public $researchId;
    public $research;
    public $viewSupervise;
    public $researchSupervise;
    protected $listeners = [
        'refresh_ArSysStudentResearchPageSupervise' => '$refresh',
    ];
    public function render()
    {
        $this->research = Research::where('id', $this->researchId)->first();
        if($this->research){
            if($this->research->active){
                $this->viewSupervise = true;
            }

            if($this->research->supervise->isNotEmpty()){
                $this->researchSupervise = true;
            }else{
                $this->researchSupervise = false;
            }
        }
        return view('livewire.student.research.components.supervise');
    }


    public function superviseMeeting_ArSysStudentResearchSuperviseMeeting($researchId){
        $this->emit('superviseMeeting_ArSysStudentResearchSuperviseMeeting', $researchId );
    }
}

