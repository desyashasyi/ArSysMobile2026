<?php

namespace App\Http\Livewire\Specialization\Research\NewProposal;

use App\Models\ArSys\Research;
use Livewire\Component;

class View extends Component
{
    public $research;
    public $researchId;
    public function render()
    {
        $this->research = Research::find($this->researchId);
        return view('livewire.specialization.research.new-proposal.view');
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }

}
