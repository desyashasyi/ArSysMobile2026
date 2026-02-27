<?php

namespace App\Http\Livewire\Specialization\Research\NewProposal;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public $programId;
    public function render()
    {
        return view('livewire.specialization.research.new-proposal.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
        $this->programId = Auth::user()->staff->program_id;
    }
}
