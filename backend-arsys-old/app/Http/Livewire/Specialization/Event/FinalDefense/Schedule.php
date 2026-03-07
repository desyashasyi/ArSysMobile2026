<?php

namespace App\Http\Livewire\Specialization\Event\FinalDefense;

use App\Models\ArSys\Event;
use App\Models\ArSys\FinalDefenseRoom;
use Auth;
use Carbon\Carbon;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Livewire\WithPagination;
use PDF;

class Schedule extends Component
{
    public $eventId;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    use LivewireAlert;
    protected $listeners=['refresh_SpecializationComponentsRoom' => '$refresh'];
    public function render()
    {
        $rooms = FinalDefenseRoom::where('event_id', $this->eventId)
            ->paginate($perPage = 1, $columns = ['*'], $pageName = 'finalDefenseRoom');
            //->paginate(1);
        return view('livewire.specialization.event.final-defense.schedule',[
            'rooms' => $rooms,
        ]);
    }

    public function mount($eventId){
        $this->event = Event::find($eventId);
    }

    public function captureSchedule(){
        $this->applicantCount = 0;
        $this->emit('captureSchedule_SpecializationEventFinalDefensePage');
    }
    public function downloadPDF(){
        $pdf = PDF::loadView('livewire.specialization.event.final-defense.print.schedule', [
            'rooms' => FinalDefenseRoom::where('event_id', $this->eventId)->get(),
            'event' => $this->event,
            'program' => Auth::user()->staff->program,
        ])
        ->setPaper('a4', 'portrait')->output();

        return response()->streamDownload(
            fn () => print($pdf),
            Auth::user()->staff->program->code."-".Auth::user()->staff->program->abbrev
            ."-Schedule of-".$this->event->type->description." | "
            .Carbon::parse($this->event->event_date)->format('l,')
            .Carbon::parse($this->event->event_date)->format('d F Y')." "
            .Carbon::parse($this->event->event_date)->format('H:i')
            .".pdf"

        );
    }
}
