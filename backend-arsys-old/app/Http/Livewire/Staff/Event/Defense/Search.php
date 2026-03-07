<?php

namespace App\Http\Livewire\Staff\Event\Defense;

use Livewire\Component;
use App\Models\ArSys\EventApplicantDefense;
use Auth;
class Search extends Component
{
    public $search;
    public function render()
    {
        $applicant = null;
        if($this->search){
            $applicant =  EventApplicantDefense::
                whereHas('research', function($query){
                    $query->whereHas('student', function($query){
                        $query->where('number','like', '%'.$this->search.'%')
                            ->orwhere('first_name','like', '%'.$this->search.'%')
                            ->orwhere('last_name','like', '%'.$this->search.'%');
                    })
                    ->whereHas('supervisor', function($query){
                        $query->where('supervisor_Id', Auth::user()->staff->id);
                    })
                    ->orWhereHas('predefensePublished', function($query){
                        $query->whereHas('research', function($query){
                            $query->whereHas('student', function($query){
                                $query->where('number','like', '%'.$this->search.'%')
                                    ->orwhere('first_name','like', '%'.$this->search.'%')
                                    ->orwhere('last_name','like', '%'.$this->search.'%');
                            });
                        })
                        ->whereHas('examiner',  function($query){
                            $query->where('examiner_id', Auth::user()->staff->id);
                        });
                    });
                })
                ->first();

        }

        return view('livewire.staff.event.defense.search', [
            'applicant' => $applicant,
        ]);
    }
}
