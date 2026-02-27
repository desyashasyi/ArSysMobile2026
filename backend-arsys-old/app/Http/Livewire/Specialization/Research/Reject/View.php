<?php

namespace App\Http\Livewire\Specialization\Research\Reject;

use App\Models\ArSys\Research;
use Livewire\Component;

class View extends Component
{
    protected $listeners = ['viewResearch_ArSysSpecializationResearchNewView', 'refresh_ArSysSpecializationResearchNewView' => '$refresh'];

    public $research;
    public $researchId;
    public function render()
    {
        return view('livewire.specialization.research.reject.view');
    }

    public function viewResearch_ArSysSpecializationResearchNewView($researchId){
        $this->researchId = $researchId;
        $this->research = Research::where('id',  $researchId)->first();
        $this->emit('researchRemark_SpecializationResearchPage', $researchId);
        $this->emit('researchReviewer_SpecializationResearchPage', $researchId);
        $this->emit('researchSupervisor_SpecializationResearchPage', $researchId);
    }

}
