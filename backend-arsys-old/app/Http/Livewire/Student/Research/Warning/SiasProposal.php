<?php

namespace App\Http\Livewire\Student\Research\Warning;

use App\Models\ArSys\Research;
use Livewire\Component;

class SiasProposal extends Component
{
    public $researchId;
    public $research;
    public function render()
    {
        $this->research = Research::find($this->researchId);
        return view('livewire.student.research.warning.sias-proposal');
    }
    public function mount($researchId){
        $this->researchId = $researchId;
    }
}
