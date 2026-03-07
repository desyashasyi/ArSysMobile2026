<?php

namespace App\Http\Livewire\Student\Research;

use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchConfig;
use App\Models\ArSys\ResearchLog;
use App\Models\ArSys\ResearchLogType;
use App\Models\ArSys\Student;
use Auth;
use Carbon\Carbon;
use Livewire\Component;

class Idx extends Component
{
    public $addResearch;
    public function render()
    {
        if(ResearchConfig::where('program_id', Auth::user()->student->program_id)->get()->isEmpty()){
            return view('livewire.student.research.parking')->layout('adminlte::page');
        }else{
            return view('livewire.student.research.idx')->layout('adminlte::page');
        }

    }

    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }else{
            if(is_null(Student::where('number', Auth::user()->sso)->first())){
                return redirect()->route('arsys.user.profile.create');
            }else{
                Student::where('number', Auth::user()->sso)->update([
                    'user_id' => Auth::user()->id,
                ]);
                /*if(is_null(Auth::user()->telegram)){
                    return redirect()->route('arsys.telegram');
                }
                */

            }
        }

        /**
         * Ini modul/fungsi untuk
         *
         */
        /*$researchs = Research::where('student_id', Auth::user()->student->id)->get();
        foreach($researchs as $research){
            if($research->history->contains('type_id',ResearchLogType::where('code','ACT')->first()->id)){
                if(!is_null($research->active)){
                    if(Carbon::parse($research->active->created_at)->addDay(180)->lte(Carbon::now())){
                        if($research->active){
                            ResearchLog::create([
                                'research_id' => $research->id,
                                'loger_id' => Auth::user()->id,
                                'type_id' => ResearchLogType::where('code','FRE')->first()->id,
                                'message' => ResearchLogType::where('code','FRE')->first()->description,
                                'status' => 1,
                            ]);
                            /*ResearchLog::find($research->active->id)->update([
                                'status' => null,
                            ]);

                        }
                    }
                }
            }
        }
        */

    }

}
