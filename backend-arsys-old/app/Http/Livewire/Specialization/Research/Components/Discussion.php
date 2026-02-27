<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Http\Livewire\Arsys\Specialization\Research\Components\Research;
use Livewire\Component;

class Discussion extends Component
{
    public $researchId;
    public function render()
    {
        $research = Research::where('id', $this->researchId)->first();
        return view('livewire.specialization.research.components.reviewer', ['research' => $research]);
    }

    public function mount($researchId){
        $this->researchId = $researchId;
    }
}
