<?php

namespace App\Http\Livewire\Staff\Event\Components;

use Livewire\Component;
use \App\Models\ArSys\Staff;
use App\Models\ArSys\Program;
use \App\Models\ArSys\EventApplicantDefense;
use \App\Models\ArSys\DefenseExaminer;
use Livewire\WithPagination;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Auth;
class Examiner extends Component
{
    public $addExaminer = false;
    public $applicantId;
    public $includeCluster;
    use WithPagination;
    use LivewireAlert;
    protected $paginationTheme = 'bootstrap';
    public $search;
    public function render()
    {

        $staffs = collect();
        $programs = collect();
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
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'Examiner');

            }else{
                $staffs = Staff::where('program_id', $research->student->program_id)
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 10, $columns = ['*'], $pageName = 'Examiner');
            }

            if ($this->search != null) {
                $staffs = Staff::where('first_name', 'like', '%' . $this->search . '%')
                    ->orwhere('last_name', 'like', '%' . $this->search . '%')
                    ->orwhere('code', 'like', '%' . $this->search . '%')
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 10, $columns = ['*'], $pageName = 'Examiner');
            }
        }
        return view('livewire.staff.event.components.examiner', compact('staffs', 'research', 'programs'));
    }

    public function mount($applicantId){
        $this->applicantId = $applicantId;
    }
    public function enableAddExaminer(){
        if($this->addExaminer == false){
            $this->addExaminer = true;
        }else{
            $this->addExaminer = false;
        }
    }

    public function assignExaminer($staffId){
        if(!EventApplicantDefense::find($this->applicantId)->research->supervisor
            ->contains('supervisor_id', $staffId)){
            if(EventApplicantDefense::find($this->applicantId)->defenseExaminerAdditional->count() < 2 ){
                if(!EventApplicantDefense::find($this->applicantId)->defenseExaminerAdditional->contains('examiner_id', $staffId)){
                    $examinerOrder = null;
                    if(EventApplicantDefense::find($this->applicantId)->defenseExaminer->count() == 0){
                        $examinerOrder = 1;
                    }
                    DefenseExaminer::create([
                        'examiner_id' => $staffId,
                        'applicant_id' => $this->applicantId,
                        'order' => $examinerOrder,
                        'event_id' => EventApplicantDefense::find($this->applicantId)->event->id,
                        'additional' => 1,
                    ]);
                }
                $this->emit('refresh_ArSysStaffEventDefense');
                $this->addExaminer = false;
            }
        }else{
            $this->alert('info', 'The staff name is the research supervisor',[
                'position' => 'top',
            ]);
        }
    }

}
