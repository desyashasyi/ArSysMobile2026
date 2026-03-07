<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchMilestone;
use Livewire\Component;

class Report extends Component
{
    protected $listeners =['report_ArSysStudentResearch'];
    public $mode;
    public $defense;
    public $messageReport;
    public $researchId;
    public function render()
    {
        return view('livewire.student.research.components.report');
    }

    public function report_ArSysStudentResearch($researchId, $mode){
        $this->researchId = $researchId;
        $this->mode = $mode;
        $this->defense = EventApplicantDefense::where('research_id', $researchId)->first();
        $this->messageReport = $this->defense->report;
        $this->emit('report_ArSysStudentResearchModal');
    }
    public function hydrate(){
        $this->emit('setSummernoteMessageSpecializationRemark');
    }

    public function saveReport(){

        $this->validate([
            'messageReport' => 'required',
        ]);
        EventApplicantDefense::where('research_id', $this->researchId)->update([
            'status' => 1,
            'report' => str_replace('<p>', '<p style="margin:0">', $this->messageReport),
        ]);
        Research::find($this->researchId)->update([
            'milestone_id' => ResearchMilestone::where('code', 'Final-defense')
                            ->where('phase', 'In Progress')->first()->id,
        ]);

        $this->emit('refresh_ArSysStudentResearchPage');
        $this->emit('refresh_ArSysStudentResearchAction');
        $this->emit('refreshInformation_ArSysComponentsResearchInformation');

    }
}
