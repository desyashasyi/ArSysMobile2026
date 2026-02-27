<?php

namespace App\Exports;


use App\Invoice;
use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\Models\ArSys\EventApplicantFinalDefense;
use Maatwebsite\Excel\Concerns\WithColumnWidths;

class FinalDefenseMark implements FromView, WithColumnWidths
{
    public $eventId;
    public function __construct(int $eventId)
    {
        $this->eventId = $eventId;
    }
    public function view(): View
    {
        return view('livewire.program.research.final-defense.print.mark', [
            'eventApplicants' =>  EventApplicantFinalDefense::where('event_id', $this->eventId)
                                    ->orderBy('room_id', 'ASC')->get()
        ]);
    }

    public function columnWidths(): array
    {
        return [
            'A' => 5,
            'B' => 15,
            'C' => 40,
            'D' => 10,
            'E' => 10,
            'F' => 10,
            'G' => 10,
            'H' => 10,
            'I' => 10,
            'J' => 10,
            'K' => 15,
            'L' => 20,
            'M' => 15,
            'N' => 10,
            'O' => 10,
            'P' => 15,
            'Q' => 10,
            'R' => 10,
            'S' => 10,
            'T' => 10,
            'U' => 10,

        ];
    }
}
