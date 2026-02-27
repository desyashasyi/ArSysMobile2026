<?php

namespace App\Http\Livewire\Student\Research\Warning;

use App\Models\ArSys\Research;
use Livewire\Component;

class Rejected extends Component
{
    public $researchId;
    public $research;
    protected $listeners= ['viewResearch_ArSysStudentResearchViewWarningRejected'];
    public function render()
    {
        if( $this->researchId){
            $this->research = Research::find($this->researchId);
        }
        return view('livewire.student.research.warning.reject');
    }

    public function viewResearch_ArSysStudentResearchViewWarningRejected($researchId){
        $this->researchId = $researchId;
    }
}
