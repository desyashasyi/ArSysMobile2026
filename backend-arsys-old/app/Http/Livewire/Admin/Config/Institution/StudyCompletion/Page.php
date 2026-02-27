<?php

namespace App\Http\Livewire\Admin\Config\Institution\StudyCompletion;

use App\Models\ArSys\InstitutionConfig;
use App\Models\ArSys\Staff;
use App\Models\ArSys\StudyCompletion;
use App\Models\ArSys\StudyCompletionTeam;
use App\Models\User;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $enableStudyCompletion = false;
    use WithPagination;
    use LivewireAlert;
    public $viewStudyCompletionIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageNumber = null;
    public $viewStudyCompletion = false;
    public $studyCompletionId;
    public $staff_vs_staffClerk = false;
    protected $paginationTheme = 'bootstrap';

    protected $listeners = ['viewStudyCompletionPage_ArSysAdminConfigInstitutionPage',
                                'refresh_ArSysAdminConfigInstitutionStudyCompletionPage' => '$refresh',
                                'pickUpStaffName' => 'pickUpStaffName'
                            ];
    public function render()
    {
        $studyCompletions = StudyCompletion::where('program_id', Auth::user()->sysrole->program_id)
                            ->paginate(5);
                            //->get();
        if($this->pageNumber != $studyCompletions->currentPage()){
            foreach($studyCompletions as $index => $studyCompletion){
                $this->viewStudyCompletionIndex[$index] = null;
            }
            $this->pageNumber = $studyCompletions->currentPage();
            $this->tempIndex = $studyCompletions->count()+1;
            $this->viewIndex = $studyCompletions->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->viewStudyCompletionIndex[$this->viewIndex] = 1;
            $this->viewStudyCompletionIndex[$this->tempIndex] = null;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewStudyCompletion == true){
                $this->viewStudyCompletionIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.admin.config.institution.study-completion.page',
                [
                    'studyCompletions' => $studyCompletions,
                ]);
    }

    public function viewStudyCompletionPage_ArSysAdminConfigInstitutionPage($configId){
        if(InstitutionConfig::find($configId)->status == 1){
            $this->enableStudyCompletion = true;
        }else{
            $this->enableStudyCompletion = false;
        }
    }

    public function addTeam($viewId, $studyCompletionId){
        $this->studyCompletionId = $studyCompletionId;
        $this->viewStudiCompletion = true;
        $this->viewIndex = $viewId;
        $this->viewStudyCompletionIndex[$this->viewIndex] = 1;
        $this->viewStudyCompletionIndex[$this->tempIndex] = 0;
    }
    public function pickUpStaffName($staffId){
        if(is_null(StudyCompletionTeam::where('study_completion_id', $this->studyCompletionId)
                ->where('staff_id', $staffId)->first())){
                StudyCompletionTeam::create([
                    'study_completion_id' => $this->studyCompletionId,
                    'staff_id' => $staffId,
                ]);
                if(is_null(User::where('name',Staff::find($staffId)->code)->first())){
                    User::create([
                        'name' => Staff::find($staffId)->code,
                        'sso' => Staff::find($staffId)->sso,
                    ]);
                    Staff::find($staffId)->update([
                        'user_id' => User::where('name',Staff::find($staffId)->code)->first()->id,
                    ]);
                }
                if(StudyCompletion::find($this->studyCompletionId)->base->code == 'RES'){
                    User::find(Staff::find($staffId)->user_id)->assignRole('research');
                }
                if(StudyCompletion::find($this->studyCompletionId)->base->code == 'DEF'){
                    User::find(Staff::find($staffId)->user_id)->assignRole('defense');
                }
        }else{
            $this->alert('error', 'The staff has been asigned in another role');
        }
    }

    public function closeView(){
        $this->viewStudiCompletion = false;
        $this->viewStudyCompletionIndex[$this->viewIndex] = 0;
        $this->viewStudyCompletionIndex[$this->tempIndex] = 0;
    }

    public function delete($teamId){

        if(StudyCompletion::find(StudyCompletionTeam::find($teamId)->study_completion_id)->base->code == 'RES'){
            User::find(Staff::find(StudyCompletionTeam::find($teamId)->staff->id)->user_id)->removeRole('research');
        }
        if(StudyCompletion::find(StudyCompletionTeam::find($teamId)->study_completion_id)->base->code == 'DEF'){
            User::find(Staff::find(StudyCompletionTeam::find($teamId)->staff->id)->user_id)->removeRole('defense');
        }
        StudyCompletionTeam::find($teamId)->delete();
    }

    public function setstaff_vs_staffClerk(){
        if($this->staff_vs_staffClerk){
            $this->staff_vs_staffClerk = false;
        }else{
            $this->staff_vs_staffClerk = true;
        }
    }

}
