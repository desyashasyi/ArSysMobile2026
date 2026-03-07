<?php

namespace App\Http\Livewire\Admin\Config\Institution\StudyCompletion;

use App\Models\ArSys\StudyCompletion;
use Auth;
use Illuminate\Support\Str;
use Livewire\Component;

class Create extends Component
{
    public $addStudyCompletion = false;
    public $codeCreate;
    public $descriptionCreate;
    public $name;
    protected $listeners = ['pickUpStaffName' => 'pickUpStaffName'];
    public function render()
    {

        return view('livewire.admin.config.institution.study-completion.create');
    }

    public function addStudyCompletion_AdminConfigInstitutionPage(){
        if($this->addStudyCompletion){
            $this->addStudyCompletion = false;
        }else{
            $this->addStudyCompletion = true;
            $this->editStudyCompletion = false;
        }
    }

    protected $rules =[
        'codeCreate' => 'required',
        'descriptionCreate' => 'required',
        //'headOfSpecializationCreate' => 'required',
    ];

    protected $messages =[
        'codeCreate.required' => 'The specialization code is mandatory',
        'descriptionCreate.required' => 'The description of specialization is mandatory',
        //'headOfSpecializationCreate.required' => 'The head of specialization is mandatory',
    ];
    public function saveStudiCompletion_ArSysAdminConfigInstitutionPage(){
        $this->validate();
        StudyCompletion::updateOrCreate([
            'code' => Str::upper($this->codeCreate),
            'description' => Str::title($this->descriptionCreate),
            'program_id' => Auth::user()->sysrole->program_id,
        ]);



        $this->codeCreate = null;
        $this->descriptionCreate = null;
        $this->emitUp('refresh_ArSysAdminConfigInstitutionStudyCompletionPage');
    }


    public function pickUpStaffName($staffId){
        $this->team  = $staffId;
    }
}
