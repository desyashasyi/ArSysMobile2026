<?php

namespace App\Http\Livewire\SuperAdmin\Student\Components;

use App\Models\ArSys\Student;
use Livewire\Component;

class View extends Component
{
    public $studentId;
    protected $listeners = ['viewStudent_ArSysAdminStudenView', 'studentViewDisable_AdminUserStudent'];
    public function render()
    {
        $student= Student::where('id', $this->studentId)->first();
        return view('livewire.super-admin.student.components.view', ['student' => $student]);
    }
    public function viewStudent_ArSysAdminStudenView($studentId){
        $this->studentId =$studentId;
    }
}
