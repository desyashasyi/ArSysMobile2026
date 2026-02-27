<?php

namespace App\Http\Livewire\Staff\Research\Components;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchSupervise;
use App\Models\ArSys\ResearchSupervisor;
use Livewire\Component;

class Supervise extends Component
{
    public $researchId;
    public $research;
    public $viewSupervise;
    protected $listeners = [
        'refresh_ArSysStaffResearchPageSupervise' => '$refresh',
        'supervise_ArSysStaffResearchPage'
    ];
    public function render()
    {
        if($this->researchId){
            $this->research = Research::find($this->researchId);
        }
        return view('livewire.staff.research.components.supervise');
    }

    public function supervise_ArSysStaffResearchPage($researchId){
        $this->researchId = $researchId;
        $this->viewSupervise = true;
    }

    public function bypass($supervisorId){
        if(ResearchSupervisor::find($supervisorId)->bypass == 1){
            ResearchSupervisor::find($supervisorId)->update([
                'bypass' => 0,
            ]);
        }else{
            ResearchSupervisor::find($supervisorId)->update([
                'bypass' => 1,
            ]);
        }

    }

    public function approveMeeting($superviseId){
        if(is_null(ResearchSupervise::find($superviseId)->status)){
            ResearchSupervise::find($superviseId)->update([
                'status' => 1,
            ]);
        }else{
            ResearchSupervise::find($superviseId)->update([
                'status' => null,
            ]);
        }
    }

}
