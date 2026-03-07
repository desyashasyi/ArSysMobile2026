<?php

namespace App\Http\Livewire\Admin\Config\Research;

use App\Models\ArSys\ResearchType;
use Livewire\Component;

class TypeView extends Component
{
    public $researchTypeId;
    public $researchType;
    public function render()
    {
        $this->researchType = ResearchType::find($this->researchTypeId);
        return view('livewire.admin.config.research.type-view');
    }

    public function mount($researchTypeId){
        $this->researchTypeId;
    }
}
