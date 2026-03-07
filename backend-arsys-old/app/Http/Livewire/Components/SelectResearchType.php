<?php

namespace App\Http\Livewire\Components;

use App\Models\ArSys\Program;
use App\Models\ArSys\ResearchType;
use Livewire\Component;

class SelectResearchType extends Component
{

    public $programId;
    public $researchTypes;
    public $researchTypeId;
    protected $listeners =['sendResearchType'];
    public function render()
    {
        if($this->programId){
            $this->researchTypes = ResearchType::where('program_id', $this->programId)
            ->whereHas('data',function($query){
                $query->where('level_id', Program::find($this->programId)->level_id);
            })
            ->get();
        }
        return view('livewire.components.select-research-type');
    }

    public function mount($programId){
        $this->programId = $programId;
    }

    public function hydrate(){
        $this->emit('reloadSelectResearchType');
    }

    public function sendResearchType(){
        $this->emit('selectResearchType', $this->researchTypeId);
    }
}
