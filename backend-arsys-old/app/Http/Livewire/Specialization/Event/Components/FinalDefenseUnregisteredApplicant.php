<?php

namespace App\Http\Livewire\Specialization\Event\Components;

use App\Models\ArSys\DefenseModel;
use App\Models\ArSys\EventApplicantFinalDefenseExtra;
use App\Models\ArSys\Research;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class FinalDefenseUnregisteredApplicant extends Component
{
    public $eventId;
    public $addUnregisteredStudent;
    protected $paginationTheme = 'bootstrap';
    use WithPagination;
    public function render()
    {
        $unregisteredResearchs = collect();
        $extraResearchs = collect();
        if(!is_null($this->addUnregisteredStudent)){
                $unregisteredResearchs = Research::whereHas('student', function($query){
                    return $query->where('program_id', Auth::user()->staff->program_id);
                })
                ->whereDoesntHave('finaldefenseAExtra')
                ->whereHas('milestone', function($query){
                    $query->where('id', 11)->orWhere('id', 12);
                })
                ->paginate($perPage = 3, $columns = ['*'], $pageName = 'unregisteredResearch');


            $extraResearchs = EventApplicantFinalDefenseExtra::where('event_id', $this->eventId)
                ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)
                ->whereHas('research', function($query){
                    $query->whereHas('student', function ($query){
                        $query->where('program_id', Auth::user()->staff->program_id);
                    });

                })
                ->paginate($perPage = 3, $columns = ['*'], $pageName = 'additionalResearch');


        }
        return view('livewire.specialization.event.components.final-defense-unregistered-applicant',[
            'unregisteredResearchs' => $unregisteredResearchs,
            'extraResearchs' => $extraResearchs,
        ]);
    }
    public function mount($eventId){
        $this->eventId = $eventId;
    }

    public function addStudents(){
        if($this->addUnregisteredStudent == null){
            $this->addUnregisteredStudent = 1;
        }else{
            $this->addUnregisteredStudent = null;
        }

    }
    public function addResearch($researchId){
        if(is_null(EventApplicantFinalDefenseExtra::where('research_id', $researchId)
            ->where('event_id', $this->eventId)->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)->first())){
                EventApplicantFinalDefenseExtra::create([
                    'research_id' => $researchId,
                    'event_id' => $this->eventId,
                    'defense_model_id' => DefenseModel::where('code', 'PUB')->first()->id,
                ]);
        }else{
            EventApplicantFinalDefenseExtra::where('research_id', $researchId)->where('event_id', $this->eventId)
                ->where('defense_model_id', DefenseModel::where('code', 'PUB')->first()->id)->delete();
        }
    }
}
