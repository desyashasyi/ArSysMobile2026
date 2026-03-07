<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\Event;
use App\Models\ArSys\EventType;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\ResearchMilestone;
use App\Models\ArSys\ResearchModel;
use Auth;
use Carbon\Carbon;
use Livewire\Component;

class FinalDefenseSetComplete extends Component
{
    public function render()
    {
        return view('livewire.specialization.event.components.final-defense-set-complete');
    }

    public function mount(){
        if(Auth::user()->hasRole('defense')){
            $events = Event::
                where('event_type_id', EventType::where('code', 'PUB')->first()->id)
                ->where('program_id', Auth::user()->staff->program->id)
                ->where('completed', null)
                ->where('status', 1)
                ->where('event_date', '<=', Carbon::today()->subDay(7))
                ->get();
            if(!is_null($events)){
                foreach($events as $event){
                    Event::find($event->id)->update([
                        'completed' => 1,
                    ]);

                    foreach($event->finaldefenseApplicant as $applicant){
                        //dd(Research::find($applicant->research_id));
                        //dd(ResearchMilestone::where('research_model_id', ResearchModel::where('code', 'DEF')->first()->id)
                        //->where('code', 'Graduated')->first()->id);
                        Research::find($applicant->research_id)->update([
                            'milestone_id' => ResearchMilestone::where('research_model_id', ResearchModel::where('code', 'DEF')->first()->id)
                                                ->where('code', 'Graduated')->first()->id,
                        ]);

                        ResearchLog::where('research_id', $applicant->research_id)
                        ->where('type_id', ResearchLogType::where('code','ACT')->first()->id)
                        ->update([
                            'status' => null,
                        ]);
                    }
                }
            }
        }
    }
}
