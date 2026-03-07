<?php

namespace App\Http\Livewire\SuperAdmin\Staff;

use App\Models\ArSys\Staff;
use App\Models\ArSys\StaffRoleBase;
use App\Models\ArSys\StaffType;
use App\Models\User;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Page extends Component
{
    use WithPagination;

    protected $listeners=['addStaff_AdminStaffPage'];
    public $viewStaffIndex = [];
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $viewIndex = null;
    public $tempIndex = null;
    public $viewStaff = null;
    public $pageNumber = null;
    public $search;
    public function render()
    {
        $staffs = Staff::orderBy('univ_code', 'ASC')
            ->where('staff_type_id', StaffType::where('code', 'PNS')->first()->id)
            ->orwhere('staff_type_id', StaffType::where('code', 'PTU')->first()->id)
            ->orwhere('staff_type_id', StaffType::where('code', 'DLB')->first()->id)
            ->paginate(10);

        if($this->search != null){
            $staffs = Staff::orderBy('univ_code', 'ASC')
                ->where('first_name','like', '%'.$this->search.'%')
                ->orwhere('last_name','like', '%'.$this->search.'%')
                ->orwhere('code','like', '%'.$this->search.'%')
                ->orwhere('employee_id','like', '%'.$this->search.'%')
                ->orderBy('univ_code', 'ASC')
                ->paginate(10);
        }

        if($this->pageNumber != $staffs->currentPage()){
            foreach($staffs as $index => $staff){
                $this->viewStaffIndex[$index] = null;
            }
            $this->pageNumber = $staffs->currentPage();
            $this->tempIndex = $staffs->count()+1;
            $this->viewIndex = $staffs->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->viewStaffIndex[$this->viewIndex] = 1;
            $this->viewStaffIndex[$this->tempIndex] = null;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewStaff == true){
                $this->viewStaffIndex[$this->viewIndex] = 1;
            }
        }


        return view('livewire.super-admin.staff.page', ['staffs' => $staffs]);
    }

    public function mount(){
        $this->viewStaff = false;
    }
    public function expandViewStaff($viewIndex, $staffId){
        $this->viewStaff = true;
        $this->viewIndex = $viewIndex;
        $this->viewStaffIndex[$this->viewIndex] = 1;
        $this->viewStaffIndex[$this->tempIndex] = 0;
        $this->emit('viewStaff_AdminStaffView', ['staffId' => $staffId]);
    }

    public function loginAs($staffId){
        Auth::login(User::where('sso', Staff::find($staffId)->sso)->first());
        return redirect()->route('arsys.staff');
    }


    public function assignRole($staffId){
        if(is_null(User::where('sso', Staff::find($staffId)->sso)->first())){
            $user = User::create([
                'name' => Staff::find($staffId)->code,
                'sso' => Staff::find($staffId)->sso,
            ]);
            $staff = Staff::where('sso', Staff::find($staffId)->sso)->update([
                'user_id' => $user->id,
            ]);
            //dd(Staff::where('sso', $user->sso)->first()->role->contains('staff_role_base_id', StaffRoleBase::where('code', 'LEC')->first()->id));
            if(Staff::where('sso', $user->sso)->first()->role->contains('staff_role_base_id', StaffRoleBase::where('code', 'LEC')->first()->id)){
                    $user->assignRole('staff');
            }elseif(Staff::where('sso', $user->sso)->first()->role->contains('staff_role_base_id', StaffRoleBase::where('code', 'CRK')->first()->id)){
                    $user->assignRole('operator');
            }
        }else{
            $user = User::where('sso', Staff::find($staffId)->sso)->first();
            if(Staff::where('sso', $user->sso)->first()->role->contains('staff_role_base_id', StaffRoleBase::where('code', 'LEC')->first()->id)){
                $user->assignRole('staff');
            }elseif(Staff::where('sso', $user->sso)->first()->role->contains('staff_role_base_id', StaffRoleBase::where('code', 'CRK')->first()->id)){
                    $user->assignRole('operator');
            }
        }
    }
    public function disableTelegram($staffId){

        if(is_null(Staff::find($staffId)->user->telegram_bypass)){
            User::find(Staff::find($staffId)->user_id)->update([
                'telegram_bypass' => 1,
            ]);
        }else{
            User::find(Staff::find($staffId)->user_id)->update([
                'telegram_bypass' => null,
            ]);
        }
    }
}
