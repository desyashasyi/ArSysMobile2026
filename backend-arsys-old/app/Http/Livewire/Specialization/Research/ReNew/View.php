<?php

namespace App\Http\Livewire\Specialization\Research\ReNew;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use Auth;
use Livewire\Component;

class View extends Component
{
    protected $listeners = ['viewResearch_ArSysSpecializationResearchNewView', 'refresh_ArSysSpecializationResearchNewView' => '$refresh'];

    public $research;
    public $researchId;
    public $viewRemark;
    public function render()
    {
        $this->research = Research::where('id', $this->researchId)->first();
        return view('livewire.specialization.research.re-new.view');
    }

    public function viewResearch_ArSysSpecializationResearchNewView($researchId){
        $this->researchId = $researchId;
    }

    public function mount($researchId){
        $this->researchId = $researchId;
        $this->viewRemark;
    }

    public function viewRemark(){
        if(!$this->viewRemark){
            $this->viewRemark = true;
        }else{
            $this->viewRemark = false;
        }
    }
    public function proceedToRenew($researchId){
        if($this->research->renewal){
            ResearchLog::find($this->research->renewal->id)->update([
                'status' => null,
            ]);
            ResearchLog::create([
                'research_id' => $this->researchId,
                'loger_id' => Auth::user()->id,
                'type_id' => ResearchLogType::where('code','ACT')->first()->id,
                'message' => ResearchLogType::where('code','ACT')->first()->description,
                'status' => 1,
            ]);
        }

        $this->emit('refresh_ArSysSpecializationResearchNewPage');
        $this->emit('closeView_ArSysSpecializationResearchPage');
        $this->emit('refresh_ArSysSpecializationResearchPage');
    }

}

