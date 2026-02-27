<?php

namespace App\Http\Livewire\SuperAdmin\Student;

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
        /*$studentUsers = Student::orderBy('number', 'ASC')->paginate(10);
        if($this->search != null){
            $studentUsers = Student::where('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%')
                    ->orwhere('number','like', '%'.$this->search.'%')
                    ->orderBy('number', 'ASC')
                    ->paginate(10);
        }
        */
        $studentUsers = User::whereRaw('LENGTH(sso) <= 7')
            ->whereRaw('LENGTH(sso) > 4')
            ->paginate($perPage = 10, $columns = ['*'], $pageName = 'studentUser');

        if($this->search != null){
            $studentUsers = User::whereRaw('LENGTH(sso) <= 7')
                ->whereRaw('LENGTH(sso) > 4')
                ->where('sso','like', '%'.$this->search.'%')
                ->orderBy('sso', 'ASC')
                //->first();
                ->paginate(10);
                //->paginate($perPage = 10, $columns = ['*'], $pageName = 'studentUser');

        }

        if($this->pageNumber != $studentUsers->currentPage()){
            foreach($studentUsers as $index => $research){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $studentUsers->currentPage();
            $this->tempIndex = $studentUsers->count()+1;
            $this->viewIndex = $studentUsers->count()+1;
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
        return view('livewire.super-admin.student.page', ['studentUsers' => $studentUsers]);
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
        $this->render();
    }

    public function closeView_ArSysAdminStudentPage(){
        $this->viewStudent = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
    }

    public function loginAs($userId){

        Auth::login(User::find($userId));
        return redirect()->route('arsys.student');
    }
}
