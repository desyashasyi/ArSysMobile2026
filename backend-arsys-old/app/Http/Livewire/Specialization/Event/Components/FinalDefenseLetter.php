<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\Event;
use App\Models\ArSys\EventApplicantFinalDefense;
use App\Models\ArSys\EventApplicantFinalDefenseExtra;
use App\Models\ArSys\EventLetter;
use App\Models\ArSys\EventLetterType;
use Auth;
use Livewire\Component;
use PDF;

class FinalDefenseLetter extends Component
{
    public $eventId;
    public $deanInvitation;
    public $staffAssignment;
    public $yudiciumProposal;
    public $event;
    public $letterCount;
    public $letter;
    public $finalDefenseLetter = null;
    public function render()
    {
        $this->letterCount = $this->event->letter->where('program_id', Auth::user()->staff->program->id)->count();
        return view('livewire.specialization.event.components.final-defense-letter');
    }

    public function mount($eventId){
        $this->eventId = $eventId;
        $this->event = Event::find($this->eventId);
        $this->letterCount = $this->event->letter->where('program_id', Auth::user()->staff->program->id)->count();
        $this->letter = $this->event->letter->where('program_id', Auth::user()->staff->program->id);
        if($this->letterCount != 0){
            if(!is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'DEANINV')->first()->id)->first())){
                $this->deanInvitation = $this->event->letter->where('program_id', Auth::user()->staff->program->id)
                ->where('type_id', EventLetterType::where('code', 'DEANINV')->first()->id)->first()->number;
            }

            if(!is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'STAFFASS')->first()->id)->first())){
                $this->staffAssignment = $this->event->letter->where('program_id', Auth::user()->staff->program->id)
                    ->where('type_id', EventLetterType::where('code', 'STAFFASS')->first()->id)->first()->number;
            }

            if(!is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'YUDPRO')->first()->id)->first())){
                $this->yudiciumProposal = $this->event->letter->where('program_id', Auth::user()->staff->program->id)
                    ->where('type_id', EventLetterType::where('code', 'YUDPRO')->first()->id)->first()->number;
            }

        }
    }

    public function addLetter(){
        $this->validate([
            'deanInvitation' => 'required',
            'staffAssignment' => 'required',
            'yudiciumProposal' => 'required',
        ]);

        if(is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'DEANINV')->first()->id)->first())){
                EventLetter::create([
                    'event_id' => $this->eventId,
                    'program_id' => Auth::user()->staff->program->id,
                    'type_id' => EventLetterType::where('code', 'DEANINV')->first()->id,
                    'number' => $this->deanInvitation,
                ]);
        }else{
            EventLetter::where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'DEANINV')->first()->id)->update([
                'number' => $this->deanInvitation,
            ]);

        }
        if(is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'STAFFASS')->first()->id)->first())){
                EventLetter::create([
                    'event_id' => $this->eventId,
                    'program_id' => Auth::user()->staff->program->id,
                    'type_id' => EventLetterType::where('code', 'STAFFASS')->first()->id,
                    'number' => $this->staffAssignment,
                ]);
        }else{
            EventLetter::where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'STAFFASS')->first()->id)->update([
                'number' => $this->staffAssignment,
            ]);
        }
        if(is_null($this->event->letter->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'YUDPRO')->first()->id)->first())){
                EventLetter::create([
                    'event_id' => $this->eventId,
                    'program_id' => Auth::user()->staff->program->id,
                    'type_id' => EventLetterType::where('code', 'YUDPRO')->first()->id,
                    'number' => $this->yudiciumProposal,
                ]);
        }else{
            EventLetter::where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', 'YUDPRO')->first()->id)->update([
                'number' => $this->yudiciumProposal,
            ]);
        }
        $this->render();
    }

    public function printProposal($letterType){
        $letter = EventLetter::where('event_id', $this->eventId)->where('program_id', Auth::user()->staff->program->id)
            ->where('type_id', EventLetterType::where('code', $letterType)->first()->id)->first();

        if($letterType == 'YUDPRO'){
            $applicants = EventApplicantFinalDefense::where('event_id', $this->eventId)
                ->whereHas('research', function($query){
                    $query->whereHas('student', function($query){
                        $query->where('program_id', Auth::user()->staff->program_id);
                    });
                })->get();
            $waitingApplicants =EventApplicantFinalDefenseExtra::where('event_id', $this->eventId)
                ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
                ->whereHas('research', function($query){
                    $query->whereHas('student', function ($query){
                        $query->where('program_id', Auth::user()->staff->program_id);
                    });

                })->get();

            //dd($waitingApplicants);
            /*$waitingApplicants = Research::whereHas('student', function($query){
                    return $query->where('program_id', Auth::user()->staff->program_id);
                })
                ->whereDoesntHave('finaldefenseAExtra')
                ->whereHas('milestone', function($query){
                    $query->where('id', 11)->orWhere('id', 12);
                })
                ->get();

            */

            $pdf = PDF::loadView('livewire.specialization.event.final-defense.print.yudicium-proposal', [
                    'applicants' => $applicants,
                    'waitingApplicants' => $waitingApplicants,
                    'program' => Auth::user()->staff->program,
                    'event' => $this->event,
                    'letter' => $letter,
                ])
                ->setPaper('legal', 'landscape')->output();

                //$pdfContent = PDF::loadView('livewire.administration.research.proposal.print.assignment', ['research' => $research])->output();
                return response()->streamDownload(
                    fn () => print($pdf),
                    Auth::user()->staff->program->code."-".Auth::user()->staff->program->abbrev."-Yudicium Proposal-".\Carbon\Carbon::parse($this->event->event_date)->format('d F Y').".pdf"

                );
        }
        if($letterType == 'DEANINV'){
            $pdf = PDF::loadView('livewire.specialization.event.final-defense.print.dean-invitation', [
                'program' => Auth::user()->staff->program,
                'event' => $this->event,
                'letter' => $letter,
            ])
            ->setPaper('A4', 'portrait')->output();
            return response()->streamDownload(
                fn () => print($pdf),
                Auth::user()->staff->program->code."-".Auth::user()->staff->program->abbrev."-Dean Invitation-".\Carbon\Carbon::parse($this->event->event_date)->format('d F Y').".pdf"

            );
        }
    }
    public function enableFinalDefenseProposal(){
        if(is_null($this->finalDefenseLetter)){
            $this->finalDefenseLetter = 1;
        }else{
            $this->finalDefenseLetter = null;
        }
    }
}
