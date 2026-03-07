<?php

namespace App\Http\Livewire\Staff\Research;

use App\Models\ArSys\Research;
use Livewire\Component;

class View extends Component
{
    public $research;
    public $researchId;
    public function render(){
        $this->research = Research::find($this->researchId);
        return view('livewire.staff.research.view');
    }

    public function mount ($researchId){
        $this->researchId = $researchId;
    }
}

