<?php

namespace App\Http\Livewire\Student\Research\Warning;

use App\Http\Livewire\Arsys\Student\Research\Warning\Auth;
use App\Http\Livewire\Arsys\Student\Research\Warning\ResearchLog;
use App\Http\Livewire\Arsys\Student\Research\Warning\ResearchLogType;
use App\Models\ArSys\Research;
use Livewire\Component;

class Freeze extends Component
{
    public $researchId;
    public $research;
    public function render()
    {
        $this->research = Research::find($this->researchId);
        return view('livewire.student.research.warning.freeze');
    }

    public function mount($researchId){
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
