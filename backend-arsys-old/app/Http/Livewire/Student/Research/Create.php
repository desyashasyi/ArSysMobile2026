<?php

namespace App\Http\Livewire\Student\Research;

use App\Models\ArSys\AcademicYear;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchConfigBase;
use App\Models\ArSys\ResearchFile;
use App\Models\ArSys\ResearchFiletype;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchMilestoneLog;
use App\Models\ArSys\ResearchType;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithFileUploads;

class Create extends Component
{

    public $researchTypes;

    use WithFileUploads;
    use LivewireAlert;

    public $researchTypeCreate;
    public $title;
    public $abstract;
    public $file;
    public $proposalUrl;
    public $addResearch = false;
    public function render()
    {
        return view('livewire.student.research.create');
    }
    public function mount(){
        $this->researchTypes = ResearchType::where('program_id', Auth::user()->student->program_id)
            ->whereHas('data',function($query){
                $query->where('level_id', Auth::user()->student->program->level_id);
            })
            ->where('status', 1)
            ->get();
        $this->title = '';
        $this->abstract = '';
        $this->file = '';
        $this->resetErrorBag();
        $this->resetValidation();
    }

    public function save(){
            /**
             * validate research title and abstract
             */
            $this->validate([
                'title' => 'required',
                'abstract' => 'required',
            ]);

            /**
             * Validate the file of research proposal or url
             */
            if(ResearchConfig::where('program_id', Auth::user()->student->program_id)
                ->where('config_base_id',ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
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

            $researchCounter = Research::where('type_id', $this->researchTypeCreate)
                ->where('student_id', Auth::user()->student->id)
                ->count();

            /**
             * Generat the research code
             */
            $code = ResearchType::where('program_id',Auth::user()->student->program_id)->where('id',$this->researchTypeCreate)->first()->data->code
                                .'-'.Auth::user()->student->number.'-'.(strval($researchCounter+1));
            Research::create([
                'student_id' => Auth::user()->student->id,
                'title' => $this->title,
                'abstract' => $this->abstract,
                'type_id' => $this->researchTypeCreate,
                'milestone_id' => ResearchMilestone::where('research_model_id',
                            ResearchType::where('program_id', Auth::user()->student->program_id)
                            ->where('id', $this->researchTypeCreate)->first()->data->research_model_id)
                            ->where('sequence', 1)->first()->id,
                'code' => $code,
                'academic_year_id' => AcademicYear::latest()->first()->id,
            ]);
            $research = Research::where('code', $code)->first();
            ResearchMilestoneLog::create([
                'research_id' => $research->id,
                'research_model_id' => ResearchType::where('program_id', Auth::user()->student->program_id)
                            ->where('id', $this->researchTypeCreate)->first()->data->research_model_id,
                'milestone_id' => ResearchMilestone::where('research_model_id',
                            ResearchType::where('program_id', Auth::user()->student->program_id)
                            ->where('id', $this->researchTypeCreate)->first()->data->research_model_id)
                            ->where('sequence', 1)->first()->id,
            ]);
            /**
             * * Check wether student should upload file of proposal
             * * or just give the url of file (in Google Drive)
             * */
            $research = Research::where('code', $code)->first();
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
             * * Log the research creation
             * */
            ResearchLog::create([
                'research_id' => $research->id,
                'loger_id' => Auth::user()->id,
                'type_id' => ResearchLogType::where('code', 'CRE')->first()->id,
                'message' => ResearchLogType::where('code', 'CRE')->first()->description,
                'status' => 1,
            ]);
            $this->alert('success', 'The research proposal has been added',[
                'position' => 'top-end',
            ]);
            return redirect()->route('arsys.student.research');
    }

    public function hydrate(){
        $this->emit('reloadSelectResearchTypeCreate');
    }

    public function addResearch(){
        if(!$this->addResearch){
            $this->addResearch = true;
        }else{
            $this->addResearch = false;
        }
    }


}
