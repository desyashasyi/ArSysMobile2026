<?php

namespace App\Http\Livewire\SuperAdmin\Config\Program;

use App\Models\ArSys\Cluster;
use App\Models\ArSys\ClusterBase;
use App\Models\ArSys\Faculty;
use App\Models\ArSys\InstitutionConfig;
use App\Models\ArSys\InstitutionConfigBase;
use App\Models\ArSys\InstitutionRole;
use App\Models\ArSys\Level;
use App\Models\ArSys\Program;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchConfigBase;
use App\Models\ArSys\ResearchType;
use App\Models\ArSys\ResearchTypeBase;
use App\Models\ArSys\Staff;
use App\Models\ArSys\StudyCompletion;
use App\Models\ArSys\StudyCompletionBase;
use App\Models\User;
use Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{

    use LivewireAlert;
    public $addProgram = false;
    public $addCluster = false;
    public $addFaculty = false;
    public $codeCreate;
    public $abbrevCreate;
    public $nameCreate;

    public $clusterCreate;
    public $facultyCreate;
    public $levelCreate;
    public $headOfProgramCreate;

    public $codeFacultyCreate;
    public $nameFacultyCreate;

    public $codeClusterCreate;
    public $nameClusterCreate;

    public $search;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $editProgram = false;
    public $programCount;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    public function render()
    {
        $clusters = ClusterBase::all();
        $faculties = Faculty::all();
        $levels = Level::all();
        $staffs = Staff::all();
        $programs = Program::orderBy('code', 'ASC')->paginate(10);
        if(!is_null($this->search)){
            $programs = Program::where('code','like', '%'.$this->search.'%')
                ->orderBy('code', 'ASC')->paginate(10);
        }
        if($this->programCount != $programs->count()){
            $this->programCount = $programs->count();
            foreach($programs as $index => $program){
                $this->expandViewIndex[$index] = null;
                $this->viewIndex = $this->programCount+1;
                $this->tempIndex = $this->programCount+1;
            }
        }
        if($this->pageNumber != $programs->currentPage()){
            foreach($programs as $index => $program){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $programs->currentPage();
            $this->tempIndex = $programs->count()+1;
            $this->viewIndex = $programs->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->editProgram == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.super-admin.config.program.page',
            [
                'programs'=>$programs,
                'clusters' => $clusters,
                'faculties' => $faculties,
                'levels' => $levels,
                'staffs' => $staffs,
            ]);
    }

    public function mount(){
        $this->editProgram = false;
        $this->addProgram = false;
    }
    public function expandView($viewId, $programId){
        $this->editProgram = true;
        $this->viewIndex = $viewId;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        $this->emit('programEdit_SuperAdmin_ConfigProgramPage_Edit', $programId);
    }

    public function loginAs($programId){
        $programCode = Program::find($programId)->code;
        if(User::find(InstitutionRole::where('code',$programCode.'-Admin' )->first()->user_id)){
            Auth::login(User::find(InstitutionRole::where('code',$programCode.'-Admin' )->first()->user_id));
            return redirect()->route('arsys.admin');
        }
    }
    public function hydrate(){
        $this->emit('reloadSelectCluster_SA_ProgramPage');
        $this->emit('reloadSelectFaculty_SA_ProgramPage');
        $this->emit('reloadSelectLevel_SA_ProgramPage');
        $this->emit('reloadSelectHeadOfProgramCreate_SA_ProgramPage');
    }

    public function addProgram_ArSysSAConfigProgramPage(){
        if($this->addProgram){
            $this->addProgram = false;
        }else{
            $this->addProgram = true;
        }
    }
    public function addCluster_ArSysSAConfigProgramPage(){
        if($this->addCluster){
            $this->addCluster = false;
        }else{
            $this->addCluster = true;
            $this->addFaculty = false;
        }
    }
    public function addFaculty_ArSysSAConfigProgramPage(){
        if($this->addFaculty){
            $this->addFaculty = false;
        }else{
            $this->addFaculty = true;
            $this->addCluster = false;
        }
    }

    protected $rules = [
        'codeCreate' => 'required',
        'abbrevCreate' => 'required',
        'nameCreate' => 'required',
        'facultyCreate' => 'required',
        'levelCreate' => 'required',
        'headOfProgramCreate' => 'required',
    ];
    protected $messages = [
            'codeCreate.required' => 'code is mandatory!',
            'abbrevCreate.required' => 'abbrev is mandatory!',
            'levelCreate.required' => 'Level of study is mandatory!',
            'headOfProgramCreate.required' => 'Head of study program is mandatory!',
            'nameCreate.required' => 'The name of study program is required',
            'faculty.required' => 'The faculty is required',
            'codeFacultyCreate.required' => 'code is mandatory!',
            'codeClusterCreate.required' => 'code is mandatory!',
            'nameFacultyCreate.required' => 'The name of faculty is required',
            'nameClusterCreate.required' => 'The name of cluster is required',
    ];

    public function saveProgram_ArSysSAConfigProgramPage(){
        $this->validate();
        if(is_null(Program::where('code',$this->codeCreate)->first())){
            Program::updateOrCreate([
                'faculty_id' => $this->facultyCreate,
                'level_id' => $this->levelCreate,
                'code' => Str::upper($this->codeCreate),
                'abbrev' => Str::upper($this->abbrevCreate),
                'name' => Str::title($this->nameCreate),
                'staff_id' => $this->headOfProgramCreate,
            ]);

            /**
             * Attach role of head program
             */

            $staff = Staff::find($this->headOfProgramCreate);
            if(is_null(User::where('name',$staff->code)->first())){
                User::create([
                    'name' => $staff->code,
                    'sso' => $staff->sso,
                ]);
            }
            Staff::find($this->headOfProgramCreate)->update([
                'user_id' => User::where('name',$staff->code)->first()->id,
            ]);

            User::where('name',$staff->code)->first()->assignRole('program');

            /**
             * Create account of program admin
             */
            if(is_null(User::where('name',Str::upper($this->codeCreate).'-Admin')->first())){
                User::where('name',Str::upper($this->codeCreate).'-Admin')->updateOrCreate([
                    'name' => Str::upper($this->codeCreate).'-Admin',
                    'sso' => Str::upper($this->codeCreate).'-Admin',
                    'email' => Str::lower($this->codeCreate).'.admin@arsys.id',
                    'password' => Hash::make(Str::lower($this->codeCreate).'Admin##'),
                ]);
            }
            User::where('name', Str::upper($this->codeCreate).'-Admin')->first()->assignRole('admin');
            InstitutionRole::where('code', Str::upper($this->codeCreate).'-Admin')->updateOrCreate([
                'code' => Str::upper($this->codeCreate).'-Admin',
                'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                'user_id' => User::where('name', Str::upper($this->codeCreate).'-Admin')->first()->id,
            ]);

            /**
             * Create account of program specialization
             */
            /*User::where('name',$this->codeCreate.'-SPEC')->updateOrCreate([
                'name' => $this->codeCreate.'-SPEC',
                'sso' => 'SPEC-'.$this->codeCreate,
                'email' => $this->codeCreate.'.spec@arsys.id'
            ]);
            User::where('name',$this->codeCreate)->first()->assignRole('specialization');
            InstitutionRole::where('code', $this->codeCreate.'-SPEC')->updateOrCreate([
                'code' => $this->codeCreate.'-SPEC',
                'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                'user_id' => User::where('name',$this->codeCreate.'-SPEC')->first()->id,
            ]);
            */

            /**
             * Create account of study program
             */
            if(is_null(User::where('name',Str::upper($this->codeCreate))->first())){
                User::where('name',Str::upper($this->codeCreate))->updateOrCreate([
                    'name' => Str::upper($this->codeCreate),
                    'sso' => Str::upper($this->codeCreate),
                    'email' => Str::lower($this->codeCreate).'.pro@arsys.id',
                    'password' => Hash::make(Str::lower($this->codeCreate).'Pro##'),
                ]);
            }
            User::where('name',Str::upper($this->codeCreate))->first()->assignRole('program');
            InstitutionRole::where('code', Str::upper($this->codeCreate))->updateOrCreate([
                'code' => Str::upper($this->codeCreate),
                'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                'user_id' => User::where('name',Str::upper($this->codeCreate))->first()->id,
            ]);



            /**
             * Create cluster for grouping similar field of study program
             */
            Cluster::where('program_id', Program::where('code', $this->codeCreate)->first()->id)
                ->updateOrCreate([
                    'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                    'cluster_base_id' => $this->clusterCreate,
                ]);

            /**
             * Create config of research
             */
            $researchConfigBase = ResearchConfigBase::all();
            foreach($researchConfigBase as $config){
                ResearchConfig::updateOrCreate([
                    'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                    'config_base_id' => $config->id,
                    'status' => $config->status,
                ]);
            }
            $researchTypeConfigBase = ResearchTypeBase::where('level_id',$this->levelCreate)->get();
            foreach($researchTypeConfigBase as $config){
                ResearchType::updateOrCreate([
                    'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                    'research_type_base_id' => $config->id,
                    'supervisor_number' => $config->supervisor_number,
                    'status' => 1,
                    'week_of_supervise' => $config->week_of_supervise,
                    'enable_week_of_supervise' => $config->enable_week_of_supervise,
                ]);
            }


            /**
             * Create config of research
             */
            $institutionConfigBase = InstitutionConfigBase::all();
            foreach($institutionConfigBase as $config){
                InstitutionConfig::updateOrCreate([
                    'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                    'config_base_id' => $config->id,
                ]);
                if($config->code == 'STUDY_COMPLETION'){
                    $studyCompletions = StudyCompletionBase::all();
                    foreach($studyCompletions as $studyCompletion){
                        StudyCompletion::create([
                            'study_completion_base_id' => $studyCompletion->id,
                            'program_id' => Program::where('code', $this->codeCreate)->first()->id,
                        ]);
                    }
                }
            }

            $this->alert('success', 'The study program has been created or updated',[
                'position' => 'top-end',
            ]);
            $this->facultyCreate = null;
            $this->clusterCreate = null;
            $this->levelCreate = null;
            $this->codeCreate = null;
            $this->abbrevCreate = null;
            $this->nameCreate = null;
            $this->headOfProgramCreate = null;
        }else{
            $this->alert('error', 'The study program already in the database',[
                'position' => 'top-end',
            ]);
        }

    }

    public function saveFaculty_ArSysSAConfigProgramPage(){
        $this->validate([
            'codeFacultyCreate' => 'required',
            'nameFacultyCreate' => 'required',
        ]);

        if(is_null(Faculty::where('code', $this->codeFacultyCreate)->first())){
            Faculty::updateOrCreate([
                'code' => $this->codeFacultyCreate,
                'name' => $this->nameFacultyCreate,
            ]);
            $this->alert('success', 'The faculty has been created or updated',[
                'position' => 'top-end',
            ]);
            $this->addFaculty = null;
            $this->codeFacultyCreate = null;
            $this->nameFacultyCreate = null;
        }else{
            $this->alert('error', 'The faculty is already in the database',[
                'position' => 'top-end',
            ]);
        }
    }
    public function saveCluster_ArSysSAConfigProgramPage(){
        $this->validate([
            'codeClusterCreate' => 'required',
            'nameClusterCreate' => 'required',
        ]);

        if(is_null(ClusterBase::where('code', $this->codeClusterCreate)->first())){
            ClusterBase::updateOrCreate([
                'code' => $this->codeClusterCreate,
                'name' => $this->nameClusterCreate,
            ]);
            $this->alert('success', 'The cluster has been created or updated',[
                'position' => 'top-end',
            ]);
            $this->addCluster = false;
            $this->addCuster = false;
            $this->codeClusterCreate = null;
            $this->nameClusterCreate = null;
        }else{
            $this->alert('error', 'The cluster is already in the database',[
                'position' => 'top-end',
            ]);
        }
    }
}
