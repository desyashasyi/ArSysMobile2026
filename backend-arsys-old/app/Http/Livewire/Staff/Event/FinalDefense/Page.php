<?php

namespace App\Http\Livewire\Staff\Event\FinalDefense;

use Livewire\Component;
use App\Models\ArSys\Event;
use Livewire\WithPagination;
use Carbon\Carbon;
use Auth;
class Page extends Component
{

    public $eventTypes;
    public $eventTypePage;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    public $pageNumber = null;
    public $viewEvent = false;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    public function render()
    {
        $events = Event::where('status', 1)//->where('event_date', '>=', Carbon::today()->subDay(90))
            ->where('event_type_id', 2)
            ->whereHas('finaldefenseApplicantPublish', function($query){
                $query->whereHas('research', function($query){
                    $query->whereHas('supervisor', function($query){
                        $query->where('supervisor_Id', Auth::user()->staff->id);
                    });
                })
                ->orWhereHas('room', function($query){
                    $query->whereHas('examiner', function($query){
                        $query->where('examiner_id', Auth::user()->staff->id);
                    });
                });
            })
            ->orderBy('event_date', 'DESC')
            ->paginate($perPage = 5, $columns = ['*'], $pageName = 'eventOfDefense');

        if($this->pageNumber != $events->currentPage()){
            foreach($events as $index => $event){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $events->currentPage();
            $this->tempIndex = $events->count()+1;
            $this->viewIndex = $events->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewEvent == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }

        return view('livewire.staff.event.final-defense.page', ['events' => $events]);
    }
    public function expandView($viewIndex){
        $this->viewEvent = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }
}
