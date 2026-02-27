<?php

namespace App\Http\Livewire\Student\Profile;

use App\Models\ArSys\Student;
use Auth;
use Livewire\Component;

class Page extends Component
{
    public $student;
    public function render()
    {
        return view('livewire.student.profile.page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
        $this->student = Student::where('user_id', Auth::user()->id)->first();
    }

    public function edit(){
        return redirect()->route('arsys.user.profile.edit');
    }

}
