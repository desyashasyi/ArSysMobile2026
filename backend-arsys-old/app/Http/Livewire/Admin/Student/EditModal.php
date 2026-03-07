<?php

namespace App\Http\Livewire\Admin\Student;

use Livewire\Component;

class EditModal extends Component
{

    public function render()
    {
        return view('livewire.admin.user.components.student.edit-modal');
    }

    public function userEdit_AdminUserStudent(){
        $this->emit('editStudentModal_AdminUserStudent_Show');
    }
}
