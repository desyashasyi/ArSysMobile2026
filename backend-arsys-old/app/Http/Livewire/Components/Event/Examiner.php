<?php

namespace App\Http\Livewire\Components\Event;

use App\Models\ArSys\DefenseExaminer;
use App\Models\ArSys\EventApplicantDefense;
use App\Models\ArSys\Program;
use App\Models\ArSys\Staff;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class Examiner extends Component
{
    use LivewireAlert;
    public $applicantId;
    public $search;
    public $includeCluster = false;
    use WithPagination;
    protected $pageName = 'examinerAdd';
    protected $paginationTheme = 'bootstrap';
    protected $listeners = ['examiner_ArSysEventExaminer'];
    public function render()
    {
        $staffs = collect();
        $programs = collect();
        $research = null;
        if($this->applicantId){
            $this->includeCluster = true;
            $programs = Program::whereHas('cluster', function($query){
                $query->where('cluster_base_id', Auth::user()->staff->program->cluster->cluster_base_id);
            })
            ->get();
            $research = EventApplicantDefense::find($this->applicantId)->research;
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
                    ->paginate($perPage = 3, $columns = ['*'], $pageName = 'Examiner');

            }else{
                $staffs = Staff::where('program_id', $research->student->program_id)
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 3, $columns = ['*'], $pageName = 'Examiner');
            }

            if ($this->search != null) {
                $staffs = Staff::where('first_name', 'like', '%' . $this->search . '%')
                    ->orwhere('last_name', 'like', '%' . $this->search . '%')
                    ->orwhere('code', 'like', '%' . $this->search . '%')
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 10, $columns = ['*'], $pageName = 'Examiner');
            }
        }
        return view('livewire.components.event.examiner', compact('staffs', 'research', 'programs'));
    }

    /*public function mount($applicantId){
        $this->applicantId = $applicantId;
    }
    */

    public function examiner_ArSysEventExaminer($applicantId){
        $this->applicantId = $applicantId;
        $this->emit('addExaminer_ArSysEventExaminer');
    }

    public function assign_Specialization($staffId){
        if(!EventApplicantDefense::find($this->applicantId)->research->supervisor
            ->contains('supervisor_id', $staffId)){
            if(EventApplicantDefense::find($this->applicantId)->defenseExaminer->count() < 3 ){
                if(!EventApplicantDefense::find($this->applicantId)->defenseExaminer->contains('examiner_id', $staffId)){
                    $examinerOrder = null;
                    if(EventApplicantDefense::find($this->applicantId)->defenseExaminer->count() == 0){
                        $examinerOrder = 1;
                    }
                    DefenseExaminer::create([
                        'examiner_id' => $staffId,
                        'applicant_id' => $this->applicantId,
                        'order' => $examinerOrder,
                        'event_id' => EventApplicantDefense::find($this->applicantId)->event->id,
                    ]);
                }
                $this->emit('refresh_ArSysSpecializationEventApplicant');
            }
        }else{
            $this->alert('info', 'The staff name is the research supervisor',[
                'position' => 'top',
            ]);
        }
    }

    public function unAssign($examinerId){
        DefenseExaminer::find($examinerId)->delete();
        $this->emit('refresh_ArSysSpecializationEventApplicant');
    }
}
