<?php

namespace App\Http\Livewire\Specialization\Research\Components\Modal;

use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchSupervisorDummy;
use App\Models\ArSys\ResearchSupervisorExternalDummy;
use App\Models\ArSys\Staff;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class SupervisorAdd extends Component
{
    protected $listeners = ['supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd',
            'unAssignSupervisor_ArSysSpecializationResearchComponentsModalSupervisorAdd' => 'unAssign'];
    public $researchId = null;
    public $search;
    public $onlySpecializationMember = false;
    use WithPagination;
    public $includeCluster = false;
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $research = Research::where('id', $this->researchId)->first();
        $staffs = null;
        $programs = null;
        $this->includeCluster = true;
        if($research){
            $programs = Program::whereHas('cluster', function($query){
                $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
            })
            ->get();
            if($this->includeCluster){
                $staffs = Staff::whereHas('program', function($query)use($research){
                        $query->whereHas('cluster', function($query)use($research){
                            $query->where('cluster_base_id', $research->student->program->cluster->data->id);
                        });
                    })
                    /*->addSelect(['supervisor' => ResearchSupervisor::selectRaw('sum(supervisor_id) as total_supervisor')
                        ->whereColumn('supervisor_id', 'id')
                        ->groupBy('supervisor_id')
                    ])
                    ->orderBy('supervisor', 'ASC')*/
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }else{
                $staffs = Staff::where('program_id', $research->student->program_id)
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }

            if ($this->search != null) {
                $staffs = Staff::where('first_name', 'like', '%' . $this->search . '%')
                    ->orwhere('last_name', 'like', '%' . $this->search . '%')
                    ->orwhere('code', 'like', '%' . $this->search . '%')
                    ->orderBy('code', 'ASC')
                    ->paginate(10);
            }

            if($this->onlySpecializationMember){
                $staffs = Staff::where('specialization_id', Auth::user()->staff->specialization_id)
                        ->orderBy('code', 'ASC')
                        ->paginate(10);
            }
        }


        return view('livewire.specialization.research.components.modal.supervisor-add',
            compact('staffs', 'research', 'programs'));
    }

    public function supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd($researchId){
        $this->researchId = $researchId;
        $this->emit('addSupervisor_ArSysSpecializationResearchSupervisorAddModal');
    }

    public function setSupervisor($id){
        $this->researchId = $id;
        $this->emit('addSupervisor_ArSysSpecializationResearchSupervisorAddModal');
    }

    public function assign($staffId){
        if(ResearchSupervisorDummy::where('research_id', $this->researchId)->count()
            <  Research::where('id', $this->researchId)->first()->type->supervisor_number){
            if(ResearchSupervisorExternalDummy::where('research_id', $this->researchId)->count()
                + ResearchSupervisorDummy::where('research_id', $this->researchId)->count() < 3){
                if (ResearchSupervisorDummy::where('research_id', $this->researchId)
                    ->where('supervisor_id', $staffId)
                    ->first() == null){
                        ResearchSupervisorDummy::updateOrCreate([
                            'research_id' => $this->researchId,
                            'supervisor_id' => $staffId,
                        ]);
                }
            }
        }
        if(Research::where('id', $this->researchId)->first()->supervisorExtra){
            if(Research::where('id', $this->researchId)->first()->supervisorExtra->status == 1
                && (ResearchSupervisorDummy::where('research_id', $this->researchId)->count()
                < Research::where('id', $this->researchId)->first()->type->supervisor_number+1)){
                    if (ResearchSupervisorDummy::where('research_id', $this->researchId)
                        ->where('supervisor_id', $staffId)
                        ->first() == null){
                            ResearchSupervisorDummy::updateOrCreate([
                                'research_id' => $this->researchId,
                                'supervisor_id' => $staffId,
                            ]);
                    }
            }
        }
        $this->emit('refresh_ArSysSpecializationResearchNewSupervisor');
    }

    public function unAssign($supervisorId){
        ResearchSupervisorDummy::where('id', $supervisorId)->delete();
        $this->emit('refresh_ArSysSpecializationResearchNewSupervisor');
    }

    public function showOnlySpecialization(){
        if($this->onlySpecializationMember == false)
            $this->onlySpecializationMember = true;
        else
            $this->onlySpecializationMember = false;
    }
    public function includeCluster(){
        if($this->includeCluster){
            $this->includeCluster = false;
        }else{
            $this->includeCluster = true;
        }
    }
}
