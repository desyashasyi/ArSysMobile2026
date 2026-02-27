<?php

namespace App\Http\Livewire\Specialization\Event\Seminar;

use App\Models\ArSys\EventApplicantSeminar;
use App\Models\ArSys\FinalDefenseRoom;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class View extends Component
{
    public $eventId = null;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageName = 'researchPage';
    public $pageNumber = null;
    public $viewApplicant = false;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;

    protected $listeners = ['refreshView_ArSysSpecializationEventApplicant_Seminar' => '$refresh'];
    public function render()
    {
        $eventApplicants = null;
        $applicants =  EventApplicantSeminar::where('event_id', $this->eventId)
            ->orderBy('room_id', 'ASC')
            ->get();
        //dd($applicants);

        $eventApplicants =  EventApplicantSeminar::where('event_id', $this->eventId)
                ->whereHas('research', function($query){
                    $query->whereHas('student', function($query){
                        $query->where('program_id', Auth::user()->staff->program_id);
                    });
                })
                //->orderBy('room_id', 'ASC')
                ->paginate($perPage = 15, $columns = ['*'], $pageName = 'seminarApplicant');
                //->get();
                //dd($eventApplicants);
        $rooms = FinalDefenseRoom::where('event_id', $this->eventId)->get();
        if($this->pageNumber != $eventApplicants->currentPage()){
            foreach($eventApplicants as $index => $applicant){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $eventApplicants->currentPage();
            $this->tempIndex = $eventApplicants->count()+1;
            $this->viewIndex = $eventApplicants->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewApplicant == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.specialization.event.seminar.view', [
            'eventApplicants' => $eventApplicants,
            'applicants' => $applicants,
            'rooms' => $rooms,
        ]);
    }

    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function expandView($viewIndex){
        $this->viewApplicant = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }

    public function confirm($applicantId){
        if(EventApplicantSeminar::find($applicantId)->confirmed == null){
            EventApplicantSeminar::find($applicantId)->update([
                'confirmed' => 1,
            ]);
        }else{
            EventApplicantSeminar::find($applicantId)->update([
                'confirmed' => null,
            ]);
        }
    }

    public function assignApplicant($roomId, $applicantId){
        EventApplicantSeminar::find($applicantId)->update([
            'room_id' => $roomId,
        ]);

        $this->emit('refresh_SpecializationComponentsRoom');
    }
}
