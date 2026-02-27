<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\FinalDefenseExaminer;
use App\Models\ArSys\FinalDefenseRoom;
use App\Models\ArSys\Program;
use App\Models\ArSys\Staff;
use Auth;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;

class FinalDefenseModeratorExaminer extends Component
{
    protected $listeners = ['moderatorAndexaminer_ArSysSpecializationFinalDefense'];
    use LivewireAlert;
    public $roomId;
    public $search;
    public $includeCluster = false;
    public $finalDefenseRole;
    use WithPagination;
    protected $pageName = 'examinerAdd';
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $staffs = collect();
        $programs = collect();
        $room = null;

        if($this->roomId){
            $room = FinalDefenseRoom::find($this->roomId);
            $this->includeCluster = true;
            $programs = Program::whereHas('cluster', function($query){
                $query->where('cluster_base_id', Auth::user()->staff->program->cluster->data->id);
            })
            ->get();
            if($this->includeCluster){
                $staffs = Staff::whereHas('program', function($query){
                        $query->whereHas('cluster', function($query){
                            $query->where('cluster_base_id', Auth::user()->staff->program->cluster->data->id);
                        });
                    })

                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'ModeratorAndExaminer');

            }else{
                $staffs = Staff::where('program_id', Auth::user()->staff->program_id)
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'ModeratorAndExaminer');
            }

            if ($this->search != null) {
                $staffs = Staff::where('first_name', 'like', '%' . $this->search . '%')
                    ->orwhere('last_name', 'like', '%' . $this->search . '%')
                    ->orwhere('code', 'like', '%' . $this->search . '%')
                    ->orderBy('code', 'ASC')
                    ->paginate($perPage = 5, $columns = ['*'], $pageName = 'ModeratorAndExaminer');
            }
        }
        return view('livewire.specialization.event.components.final-defense-moderator-examiner', compact('staffs', 'room', 'programs'));
    }

    public function moderatorAndexaminer_ArSysSpecializationFinalDefense($roomId, $role){
        $this->roomId = $roomId;
        $this->finalDefenseRole = $role;
        //dd($this->roomId, $this->finalDefenseRole);
        $this->emit('addModeratorAndExaminer_ArSysEventExaminer');
    }

    public function assign_SpecializationModeratorExaminerFinalDefense($staffId){
        if($this->finalDefenseRole == 'ModeratorExaminer'){
            FinalDefenseRoom::find($this->roomId)->update([
                'moderator_id' => $staffId,
            ]);
            $this->emit('refresh_StaffFinalDefensePage');
        }
        if($this->finalDefenseRole == 'Moderator'){
            //FinalDefenseExaminer::where('room_id', $this->roomId)->where('examiner_id', FinalDefenseRoom::find($this->roomId)->moderator_id)->delete();
            FinalDefenseRoom::find($this->roomId)->update([
                'moderator_id' => $staffId,
            ]);
            if(is_null(FinalDefenseExaminer::where('event_id', FinalDefenseRoom::find($this->roomId)->event_id)->where('examiner_id', $staffId)->first())){
                if(FinalDefenseRoom::find($this->roomId)->examiner->count() < 5){
                    FinalDefenseExaminer::create([
                        'examiner_id' => $staffId,
                        'room_id' => $this->roomId,
                        'event_id' => FinalDefenseRoom::find($this->roomId)->event_id,
                    ]);
                }
            }
        }
        if($this->finalDefenseRole == 'Examiner'){
            if(is_null(FinalDefenseExaminer::where('event_id', FinalDefenseRoom::find($this->roomId)->event_id)->where('examiner_id', $staffId)->first())){
                if(FinalDefenseRoom::find($this->roomId)->examiner->count() < 5){
                    FinalDefenseExaminer::create([
                        'examiner_id' => $staffId,
                        'room_id' => $this->roomId,
                        'event_id' => FinalDefenseRoom::find($this->roomId)->event_id,
                    ]);
                }
            }else{
                $this->alert('info', 'The examiner has been assigned in other rooms',[
                    'position' => 'top',
                ]);
            }
        }

        $this->emit('refresh_SpecializationComponentsRoom');


    }

    public function unAssign($staffId){
        if(!is_null(FinalDefenseExaminer::where('event_id', FinalDefenseRoom::find($this->roomId)->event_id)->where('examiner_id', $staffId)->first())){
            if($this->finalDefenseRole == 'Moderator'){
                FinalDefenseRoom::find($this->roomId)->update([
                    'moderator_id' => null,
                ]);
            }

            FinalDefenseExaminer::where('room_id', $this->roomId)->where('examiner_id', $staffId)->delete();
            $this->emit('refresh_SpecializationComponentsRoom');
        }else{
            $this->alert('info', 'The examiner might be double assigned',[
                'position' => 'top',
            ]);
        }
    }
}
