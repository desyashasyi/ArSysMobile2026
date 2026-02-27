<?php

namespace App\Http\Livewire\Staff\Event\FinalDefense;

use Livewire\Component;
use App\Models\ArSys\FinalDefenseRoom;
use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\FinalDefenseExaminerPresence;
use App\Models\ArSys\FinalDefenseExaminer;
use App\Models\ArSys\EventApplicantFinalDefense;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use App\Models\ArSys\Staff;
use Livewire\WithPagination;
use Auth;
class View extends Component
{
    use LivewireAlert;
    public $eventId;
    protected $listeners = ['refresh_StaffFinalDefensePage' => '$refresh', 'moderatorChangeConfirmed'];
    public $examinerPresence;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    public $supervisedApplicant;
    public public $roomId;
    public $moderatorId;
    public function render()
    {

        $finalDefenseRooms = collect();
        if(!is_null($this->eventId)){
            $finalDefenseRooms = FinalDefenseRoom::with('applicant')->where('event_id', $this->eventId)
                ->whereHas('examiner', function($query){
                    $query->where('examiner_id', Auth::user()->staff->id);
                })
                ->paginate($perPage = 1, $columns = ['*'], $pageName = 'finaldefenseRoom');
            $room = FinalDefenseRoom::where('event_id', $this->eventId)
                    ->whereHas('examiner', function($query){
                        $query->where('examiner_id', Auth::user()->staff->id);
                    })->first();
                $this->examinerPresence = null;
            if(!is_null($room)){
                $this->examinerPresence = FinalDefenseExaminerPresence::where('examiner_id',Auth::user()->staff->id)
                    ->where('room_id', $room->id)
                    ->where('event_id', $room->event->id)
                    ->get();
            }

        }
        return view('livewire.staff.event.final-defense.view', [
            'finalDefenseRooms' => $finalDefenseRooms,
        ]);
    }

    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function assignModerator($staffId, $roomId){
        $this->roomId = $roomId;
        $this->staffId = $staffId;
        $staff = Staff::where('id', $staffId)->first();
        $this->alert('question', 'Are you sure you want to overhand the moderator role to '.$staff->first_name.' '.$staff->last_name.' ?', [
            'showConfirmButton' => true,
            'confirmButtonText' => 'Yes',
            'toast' => false,
            'position' => 'center',
            'onConfirmed' => 'moderatorChangeConfirmed',
            //'allowOutsideClick' => false,
            'timer' => null
        ]);
    }

    public function moderatorChangeConfirmed(){
        FinalDefenseRoom::find($this->roomId)->update([
            'moderator_id' => $this->staffId,
        ]);
    }
    public function examinerPresence($examinerId, $roomId){
        foreach(FinalDefenseRoom::find($roomId)->applicant as $applicant){
            if(is_null(FinalDefenseExaminerPresence::where('seminar_examiner_id',$examinerId)
            ->where('room_id', $roomId)
            ->where('event_id', FinalDefenseRoom::find($roomId)->event_id)
            ->where('applicant_id', $applicant->id)->first())){
                //dd(EventApplicantFinalDefense::find($applicant->id)->research->supervisor, FinalDefenseExaminer::find($examinerId)->staff->id);
                if(EventApplicantFinalDefense::find($applicant->id)->research->supervisor
                    ->contains('supervisor_id', FinalDefenseExaminer::find($examinerId)->staff->id)){
                        FinalDefenseExaminerPresence::create([
                            'event_id' => FinalDefenseRoom::find($roomId)->event_id,
                            'room_id' => FinalDefenseRoom::find($roomId)->id,
                            'seminar_examiner_id' => $examinerId,
                            'applicant_id' => $applicant->id,
                            'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                            'examiner_id' => FinalDefenseExaminer::find($examinerId)->staff->id,
                            'score' => -1,
                        ]);
                }else{
                    FinalDefenseExaminerPresence::create([
                        'event_id' => FinalDefenseRoom::find($roomId)->event_id,
                        'room_id' => $roomId,
                        'seminar_examiner_id' => $examinerId,
                        'applicant_id' => $applicant->id,
                        'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                        'examiner_id' => FinalDefenseExaminer::find($examinerId)->staff->id,
                    ]);
                }

            }

        }
    }

    public function examinerUnPresence($examinerId){
        foreach(FinalDefenseExaminer::find($examinerId)->event->finaldefenseApplicant as $applicant){
            if(!is_null(FinalDefenseExaminerPresence::where('seminar_examiner_id',$examinerId)
            ->where('room_id', FinalDefenseExaminer::find($examinerId)->room->id)
            ->where('event_id', FinalDefenseExaminer::find($examinerId)->event->id)
            ->where('applicant_id', $applicant->id)->first())){
                FinalDefenseExaminerPresence::where('seminar_examiner_id',$examinerId)
                ->where('room_id', FinalDefenseExaminer::find($examinerId)->room->id)
                ->where('event_id', FinalDefenseExaminer::find($examinerId)->event->id)
                ->where('applicant_id', $applicant->id)->delete();
            }

        }
    }
}
