<?php

namespace App\Http\Livewire\Specialization\Event;

use App\Models\ArSys\Event;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class Edit extends Component
{
    protected $listeners =['editEvent_ArSysSpecializationEventPage'];
    public $dateOfEventEdit;
    public $applicationDeadlineEdit;
    public $draftDeadlineEdit;
    public $eventId;
    public $quota;
    use LivewireAlert;
    public function render()
    {
        return view('livewire.specialization.event.edit');
    }

    public function editEvent_ArSysSpecializationEventPage($eventId){
        $this->eventId =  $eventId;
        $this->dateOfEventEdit = Event::where('id', $this->eventId)->first()->event_date;
        $this->applicationDeadlineEdit = Event::where('id', $this->eventId)->first()->application_deadline;
        $this->draftDeadlineEdit = Event::where('id', $this->eventId)->first()->draft_deadline;
        $this->quota = Event::where('id', $this->eventId)->first()->quota;
        $this->emit('editEventModal_ArSysSpecializationEventPage');
    }

    protected $rules = [
        'dateOfEventEdit' => 'required',
        'applicationDeadlineEdit' => 'required',
        'draftDeadlineEdit' => 'required',
        'quota' => 'required',
    ];

    protected $message = [
        'dateOfEventEdit' => 'The date of event is required',
        'applicationDeadlineEdit' => 'The application deadline is required',
        'draftDeadlineEdit' => 'The draft deadline is required',
        'quota' => 'The participant quota is required',
    ];
    public function update()
    {
        $this->validate();

        //$event_type = EventType::where('id', $this->eventTypeCreate)->first();
        //$eventId = $event_type->abbrev.'-'.(Carbon::parse($this->event_date)->format('dmY'));
        Event::find($this->eventId)->update([
            //'program_id' => Auth::user()->staff->program_id,
            //'event_type_id' => $this->eventTypeCreate,
            'event_date' => $this->dateOfEventEdit,
            'application_deadline' => $this->applicationDeadlineEdit,
            'draft_deadline' => $this->draftDeadlineEdit,
            'quota' => $this->quota,

        ]);
        $this->emit('refreshEventView_SpecializationEventView');
        $this->alert('success', 'The event detail has been updated', [
            'position' => 'top'
        ]);
       $this->emit('refreshEventPage_SpecializationEventPage');
    }
}
