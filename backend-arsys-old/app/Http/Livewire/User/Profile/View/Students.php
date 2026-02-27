<?php

namespace App\Http\Livewire\User\Profile\View;

use App\Models\ArSys\Student;
use Auth;
use Livewire\Component;

class Students extends Component
{
    public $student;
    public function render()
    {
        return view('livewire.user.profile.view.students');
    }

    public function mount(){
        $this->student = Student::where('user_id', Auth::user()->id)->first();
    }

    public function edit(){
        return redirect()->route('arsys.user.profile.edit');
    }
}
