<?php

namespace App\Http\Livewire\Admin\Student;

use App\Models\ArSys\Student;
use App\Models\User;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    use WithPagination;
    protected $listeners = ['refresh_ArSysAdminStudentPage' => '$refresh',
                            'closeView_ArSysAdminStudentPage'];
    public $viewStudent = false;
    public $search;
    public function render()
    {
        $students = null;
        if(Auth::user()->sysrole){
            $students = Student::where('program_id', Auth::user()->sysrole->program_id)
            ->orderBy('number', 'ASC')
            ->paginate(10);
            if($this->search != null){
                $students = Student::where('first_name','like', '%'.$this->search.'%')
                        ->orwhere('last_name','like', '%'.$this->search.'%')
                        ->orwhere('number','like', '%'.$this->search.'%')
                        ->where('program_id', Auth::user()->sysrole->program_id)
                        ->orderBy('number', 'ASC')
                        ->paginate(10);
            }
            if($this->pageNumber != $students->currentPage()){
                foreach($students as $index => $research){
                    $this->expandViewIndex[$index] = null;
                }
                $this->pageNumber = $students->currentPage();
                $this->tempIndex = $students->count()+1;
                $this->viewIndex = $students->count()+1;
            }
            if($this->tempIndex != $this->viewIndex){
                $this->expandViewIndex[$this->viewIndex] = 1;
                $this->expandViewIndex[$this->tempIndex] = 0;
                $this->tempIndex = $this->viewIndex;
            }else{
                if($this->viewStudent == true){
                    $this->expandViewIndex[$this->viewIndex] = 1;
                }
            }
        }

        return view('livewire.admin.student.page', ['students' => $students]);
    }

    public function mount(){
        $this->viewStudent = false;
    }

    public function expandView($viewId, $studentId){
        $this->viewStudent = true;
        $this->viewIndex = $viewId;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
        $this->emit('viewStudent_ArSysAdminStudenView', $studentId);
        $this->emit('studentEdit_AdminUserStudent', $studentId);
    }

    public function closeView_ArSysAdminStudentPage(){
        $this->viewStudent = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
    }

    public function loginAs($studentId){
        if(Student::find($studentId)->user() && Student::find($studentId)->user->hasRole('student')){
            Auth::login(User::where('name', Student::find($studentId)->code)->first());
            return redirect()->route('arsys.student');
        }

    }
    public function assignUserAndRole($studentId){

        if(is_null(User::where('sso', Student::find($studentId)->number)->first())){
            User::create([
                'name' => Student::find($studentId)->code,
                'sso' => Student::find($studentId)->number,
            ]);
        }else{
            User::where('name',Student::find($studentId)->code)->first()->assignRole('student');
        }
        Student::find($studentId)->update([
            'user_id' => User::where('sso', Student::find($studentId)->number)->first()->id,
        ]);
        User::where('sso', Student::find($studentId)->number)->first()->assignRole('student');


    }
}
