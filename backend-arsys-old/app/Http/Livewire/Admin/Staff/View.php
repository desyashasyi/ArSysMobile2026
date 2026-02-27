<?php

namespace App\Http\Livewire\Admin\Staff;
use App\Models\ArSys\Staff;
use Livewire\Component;

class View extends Component
{
    public $staff;
    public $staffId;
    protected $listeners = ['viewStaff_AdminStaffView'];
    public function render()
    {
        $this->staff= Staff::where('id', $this->staffId)->first();
        return view('livewire.admin.staff.view');
    }
    public function viewStaff_AdminStaffView($staffId){
        $this->staffId = $staffId;
    }

}
