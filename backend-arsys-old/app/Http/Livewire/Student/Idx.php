<?php

namespace App\Http\Livewire\Student;

use App\Models\ArSys\Student;
use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.student.idx')->layout('adminlte::page');

        /*if(is_null(Auth::user()->student)){
            return view('livewire.student.parking')->layout('adminlte::page');
        }else{

        }*/
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
            }
            /*if(is_null(Auth::user()->telegram)){
                return redirect()->route('arsys.telegram');
            }
            */
        }
    }

}
