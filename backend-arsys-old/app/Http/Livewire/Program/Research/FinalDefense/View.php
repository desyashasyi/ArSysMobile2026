<?php

namespace App\Http\Livewire\Program\Research\FinalDefense;


use App\Models\ArSys\EventApplicantFinalDefense;
use Livewire\Component;
use Livewire\WithPagination;

class View extends Component
{
    public $eventId;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageName = 'researchPage';
    public $pageNumber = null;
    public $viewApplicant = false;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;

    protected $listeners = ['refresh_ArSysSpecializationEventApplicant' => '$refresh'];
    public function render()
    {
        $eventApplicants = null;
        if($this->eventId){
            $applicants =  EventApplicantFinalDefense::where('event_id', $this->eventId)
            ->orderBy('room_id', 'ASC')
            ->get();
            //dd($applicants);

            $eventApplicants =  EventApplicantFinalDefense::where('event_id', $this->eventId)
                    ->orderBy('room_id', 'ASC')
                    ->paginate($perPage = 15, $columns = ['*'], $pageName = 'eventApplicant');
                    //->get();
                    //dd($eventApplicants);
        }
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
        return view('livewire.program.research.final-defense.view',
        //return view('livewire.program.research.final-defense.view',
            [
                'eventApplicants' => $eventApplicants,
                'applicants' => $applicants,
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
}
