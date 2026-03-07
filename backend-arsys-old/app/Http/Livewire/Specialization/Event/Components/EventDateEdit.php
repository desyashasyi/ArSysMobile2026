<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\Event;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;

class EventDateEdit extends Component
{
    protected $listeners =['edit_ArSysSpecializationEventApplicant'];
    public $dateOfEventEdit;
    public $applicationDeadlineEdit;
    public $draftDeadlineEdit;
    public $eventId;
    public $quota;
    use LivewireAlert;
    public function render()
    {
        return view('livewire.specialization.event.components.event-date-edit');
    }

    public function edit_ArSysSpecializationEventApplicant($eventId){
        $this->eventId =  $eventId;
        $this->dateOfEventEdit = Event::where('id', $this->eventId)->first()->event_date;
        $this->emit('editEventDate_ArSysSpecializationEvenApplicant');
    }

    protected $rules = [
        'dateOfEventEdit' => 'required',
    ];

    protected $message = [
        'dateOfEventEdit' => 'The date of event is required',
    ];
    public function update()
    {
        $this->validate();

        //$event_type = EventType::where('id', $this->eventTypeCreate)->first();
        //$eventId = $event_type->abbrev.'-'.(Carbon::parse($this->event_date)->format('dmY'));
        Event::find($this->eventId)->update([
            'event_date' => $this->dateOfEventEdit,
        ]);
        $this->alert('success', 'The event detail has been updated', [
            'position' => 'top'
        ]);
       $this->emit('refresh_SpecializationEventApplicantPage');
    }
}
