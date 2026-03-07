<?php

namespace App\Http\Livewire\Specialization\Research\LoginAs;

use App\Models\ArSys\Student;
use App\Models\User;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $search;
    public function render()
    {
        $students = Student::where('program_id', Auth::user()->staff->program_id)
            ->orderBy('number', 'ASC')
            ->paginate(10);

        if($this->search != null){
            $students = Student::whereHas('program', function($query){
                    $query->where('id', Auth::user()->staff->program_id);
                })
                ->where('number','like', '%'.$this->search.'%')
                ->orwhere('first_name','like', '%'.$this->search.'%')
                ->orwhere('last_name','like', '%'.$this->search.'%')

                ->orderBy('number', 'ASC')
                ->paginate(5);
        }
        return view('livewire.specialization.research.login-as.page', ['students' => $students]);
    }

    public function loginAs($studentId){
        if(is_null(User::where('sso', Student::find($studentId)->number)->first())){
            //dd(User::where('sso', Student::find($studentId)->number)->first());
            //dd(Student::find($studentId));
            User::create([
                'name' => Student::find($studentId)->code,
                'sso' => Student::find($studentId)->number,
            ]);

        }
        Student::find($studentId)->update([


            'user_id' => User::where('sso',Student::find($studentId)->number)->first()->id,
        ]);
        User::where('sso',Student::find($studentId)->number)->first()->assignRole('student');
        Auth::login(User::where('sso', Student::find($studentId)->number)->first());
        return redirect()->route('arsys.student');
    }
}
