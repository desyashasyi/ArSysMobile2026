<?php

namespace App\Http\Livewire\Specialization\Research\InProgress;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchConfigBase;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\ResearchSupervisorDummy;
use Auth;
use Livewire\Component;

class View extends Component
{
    public $research;
    public $researchId;
    public $listeners = ['refresh_ArSysSpecializationResearchNewSupervisor' => '$refresh'];
    public function render()
    {
        $this->research = Research::find($this->researchId);
        if($this->researchId){
            if($this->research->freeze){
                return view('livewire.specialization.research.warning.freeze');
            }elseif($this->research->renewal){
                return view('livewire.specialization.research.warning.renewal');
            }elseif($this->research->SIASPro){
                if(ResearchConfig::where('program_id', Auth::user()->staff->program_id)
                        ->where('config_base_id', ResearchConfigBase::where('code', 'SIAS_PROPOSAL')->first()->id)
                        ->first()->status == 1){
                            return view('livewire.specialization.research.warning.sias-proposal');
                        }else{
                            return view('livewire.specialization.research.in-progress.view');
                        }
            }
        }
        return view('livewire.specialization.research.in-progress.view');
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function proceedAddSupervisor($researchId){
        $supervisors = ResearchSupervisorDummy::where('research_id', $researchId)->get();
            foreach($supervisors as $index => $supervisor){
                ResearchSupervisor::updateOrCreate([
                    'research_id' => $researchId,
                    'supervisor_id' => $supervisor->supervisor_id,
                    'order' => $index+1,
                ]);
                ResearchSupervisorDummy::where('id', $supervisor->id)->delete();
            }
    }

    public function cancelAddSupervisor($researchId){
        $supervisors = ResearchSupervisorDummy::where('research_id', $researchId)->get();
        foreach($supervisors as $index => $supervisor){
            ResearchSupervisorDummy::find('id', $supervisor->id)->delete();
        }
    }
}
