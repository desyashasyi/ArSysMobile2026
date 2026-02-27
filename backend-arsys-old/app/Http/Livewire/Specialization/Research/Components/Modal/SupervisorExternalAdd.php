<?php

namespace App\Http\Livewire\Specialization\Research\Components\Modal;


use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchSupervisorDummy;
use App\Models\ArSys\ResearchSupervisorExternalDummy;
use Livewire\Component;

class SupervisorExternalAdd extends Component
{
    public $researchId;
    public $externalInstitution;
    public $externalSupervisor;
    public $research;
    protected $listeners = ['externalSupervisor_ArSysSpecializationResearchNew' => 'setExternalSupervisor',
                            'unAssignExternalSupervisor_ArSysSpecializationResearchComponentsModalSupervisorExternallAdd' => 'unAssign'];
    public function render()
    {
        $this->research = Research::where('id', $this->researchId)->first();
        return view('livewire.specialization.research.components.modal.supervisor-external-add');
    }

    public function setExternalSupervisor($id){
        $this->researchId = $id;
        $this->emit('reviewSetExternalSupervisorModal');
    }

    public function assignExternalSupervisor(){
        $this->validate([
            'externalSupervisor' => 'required',
            'externalInstitution' => 'required',
        ]);
        if(is_null(ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->first())
                && ResearchSupervisorDummy::where('research_id', $this->researchId)->count() < 2){

                    $research = ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->first();
                    if($research == null){
                        ResearchSupervisorExternalDummy::create([
                            'research_id' => $this->researchId,
                            'supervisor_name' => $this->externalSupervisor,
                            'institution' => $this->externalInstitution,
                        ]);
                    }else{
                        ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->update([
                            'research_id' => $this->researchId,
                            'supervisor_name' => $this->externalSupervisor,
                            'institution' => $this->externalInstitution,
                        ]);
                    }
                    $this->emit('refresh_ArSysSpecializationResearchNewSupervisor');
        }
    }
    public function unAssign($supervisorId){
        ResearchSupervisorExternalDummy::where('id', $supervisorId)->delete();
        $this->emit('refresh_ArSysSpecializationResearchNewSupervisor');
    }
}
