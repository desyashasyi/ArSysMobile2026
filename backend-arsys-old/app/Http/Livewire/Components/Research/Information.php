<?php

namespace App\Http\Livewire\Components\Research;

use App\Models\ArSys\Research;
use Livewire\Component;

class Information extends Component
{
    public $research;
    public $researchId;
    protected $listeners = ['refreshInformation_ArSysComponentsResearchInformation' => '$refresh'];
    public function render()
    {
        $this->research = Research::find($this->researchId);
        return view('livewire.components.research.information');
    }
    public function mount($researchId){
        $this->researchId = $researchId;
    }

}
