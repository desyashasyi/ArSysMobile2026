<?php

namespace App\Http\Livewire\Student\Research;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use Auth;
use Livewire\Component;

class View extends Component
{
    public $research;
    public $researchId;

    protected $listeners = ['refreshView_ArSysStudentResearchView' => '$refresh'];
    public function render()
    {
        $this->research = Research::where('id', $this->researchId)->first();
        return view('livewire.student.research.view');
    }

    public function mount ($researchId){
        $this->researchId = $researchId;
    }

    public function renewResearch(){
        if($this->research){
            if($this->research->freeze){
                ResearchLog::where('type_id',ResearchLogType::where('code', 'FRE')->first()->id)
                    ->where('status', 1)->update([
                        'status' => null,
                    ]);

                if(is_null($this->research->renewal)){
                    ResearchLog::create([
                        'research_id' => $this->researchId,
                        'type_id' =>  ResearchLogType::where('code', 'REN')->first()->id,
                        'loger_id' => Auth::user()->id,
                        'message' => ResearchLogType::where('code', 'REN')->first()->description,
                        'status' => 1,
                    ]);
                }
            }
        }

    }

}
