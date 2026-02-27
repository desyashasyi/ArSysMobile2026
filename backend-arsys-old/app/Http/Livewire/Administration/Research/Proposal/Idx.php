<?php

namespace App\Http\Livewire\Administration\Research\Proposal;

use Auth;
use Livewire\Component;

class Idx extends Component
{
    public function render()
    {
        return view('livewire.administration.research.proposal.idx')->layout('adminlte::page');
    }
    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }
    }
}

