<?php

namespace App\Http\Livewire\Student\Research;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchConfigBase;
use App\Models\ArSys\ResearchFile;
use App\Models\ArSys\ResearchFiletype;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchType;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithFileUploads;

class Edit extends Component
{
    public $researchId;
    public $researchTypes;
    public $research;

    use WithFileUploads;
    use LivewireAlert;

    public $researchTypeEdit;
    public $title;
    public $abstract;
    public $proposalUrl;
    protected $listeners = ['editResearch_ArSysStudentResearchEdit' => 'editResearch'];
    public function render()
    {
        return view('livewire.student.research.edit');
    }

    public function editResearch($researchId){
        $this->researchId = $researchId;
        $this->research = Research::where('id',$researchId)->first();
        $this->title = $this->research->title;
        $this->abstract = $this->research->abstract;
        $this->proposalUrl = $this->research->file;
        $this->researchTypeEdit = $this->research->type_id;
        $this->resetErrorBag();
        $this->resetValidation();
        $this->emit('editResearchModal_ArSysStudentResearchEdit');
    }

    public function mount(){
        $this->researchTypes = ResearchType::where('program_id', Auth::user()->student->program_id)
            ->whereHas('data',function($query){
                $query->where('level_id', Auth::user()->student->program->level_id);
            })
            ->get();
    }
    public function hydrate(){
        $this->emit('reloadSelectResearchTypeEdit');
    }

    public function update(){
        /**
         * validate research title and abstract
         */
        $this->validate([
            'title' => 'required',
            'abstract' => 'required',
            //'researchTypeEdit' => 'required'
        ]);

        /**
         * Validate the file of research proposal or url
         */
        if(ResearchConfig::where('program_id', Auth::user()->student->program_id)
            ->where('config_base_id', ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
            ->first()->status == 1){
            $this->validate([
                'file' => "required|mimetypes:application/pdf|max:10000",
            ]);
        }else{
            $this->validate([
                'proposalUrl' => "required|url",
            ]);
        }

        /**
         * Count the number research proposal
         */
        $researchCounter = Research::where('type_id', $this->researchTypeEdit)
            ->where('student_id', Auth::user()->student->id)
            ->count();

        /**
         * Generat the research code
         */
        //$code = ResearchType::where('program_id',Auth::user()->student->program_id)->where('id',$this->researchTypeEdit)->first()->data->code
                               // .'-'.Auth::user()->student->number.'-'.(strval($researchCounter+1));

        /**
         * Create the research data
         */
        $research = Research::find($this->researchId);

        if($research){
            Research::find($this->researchId)->update([
                'title' => $this->title,
                'abstract' => $this->abstract,
                //'type_id' => $this->researchTypeEdit,
                //'code' => $code,
            ]);

            /**
             * Check wether student should upload file of proposal
             * or just give the url of file (in Google Drive)
             */
            $research = Research::where('id', $this->researchId)->first();
            if(ResearchConfig::where('program_id', Auth::user()->student->program_id)
                ->where('config_base_id',ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                ->first()->status == 1){
                $filename = $this->file->storeAs('proposal', Auth::user()->student->first_name.'-'.$research_id.'-proposal.pdf','public');
                $file = [
                    'research_id' => $research->id,
                    'file_type' => ResearchFiletype::where('code', 'PRO')->first()->id,
                    'filename' => $filename,
                ];
                ResearchFile::create($file);
            }else{
                Research::where('id',  $research->id)->update([
                    'file' => $this->proposalUrl,
                ]);
            }

            /**
             * Log the research creation
             */
            ResearchLog::create([
                'research_id' => $this->researchId,
                'loger_id' => Auth::user()->id,
                'type_id' => ResearchLogType::where('code', 'UPD')->first()->id,
                'message' => ResearchLogType::where('code', 'UPD')->first()->description,
                'status' => 1,
            ]);
            $this->alert('success', 'The research proposal has been update',[
                'position' => 'top-end',
            ]);
            //$this->emit('editResearchModal_Hide_ArSysStudentResearchEdit');
            $this->emit('refresh_ArSysStudentResearchPage');
        }
}
}
