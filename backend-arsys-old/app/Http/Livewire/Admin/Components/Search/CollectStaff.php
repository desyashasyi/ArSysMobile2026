<?php

namespace App\Http\Livewire\Admin\Components\Search;

use App\Models\ArSys\Program;
use App\Models\ArSys\Staff;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class CollectStaff extends Component
{
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public $search;
    public function render()
    {
        if(!is_null(Program::where('id', Auth::user()->sysrole->program_id)->first())){
            $staffs = Staff::whereHas('cluster', function($query){
                $query->where('id', Auth::user()->sysrole->program_id);
            })
            ->paginate(2);
        }else{
            $staffs = Staff::where('program_id', Auth::user()->sysrole->program_id)->paginate(5);
        }
        if(!is_null($this->search)){
            if(!is_null(Program::where('id', Auth::user()->sysrole->program_id)->first())){
                $staffs = Staff::whereHas('cluster', function($query){
                    $query->where('id', Auth::user()->sysrole->program_id);
                })
                ->where('first_name','like', '%'.$this->search.'%')
                ->orwhere('last_name','like', '%'.$this->search.'%')
                ->orwhere('code','like', '%'.$this->search.'%')
                ->paginate(2);
            }else{
                $staffs = Staff::where('program_id', Auth::user()->sysrole->program_id)
                ->where('first_name','like', '%'.$this->search.'%')
                ->orwhere('last_name','like', '%'.$this->search.'%')
                ->orwhere('code','like', '%'.$this->search.'%')
                ->paginate(2);
            }
        }

        return view('livewire.admin.components.search.collect-staff',
                    ['staffs' => $staffs]);
    }
}
