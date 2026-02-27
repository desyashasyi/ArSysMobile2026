<?php

namespace App\Http\Livewire\Components\Telegram;

use Auth;
use Illuminate\Support\Str;
use Livewire\Component;

class Idx extends Component
{
    public $programId;
    public function render()
    {
        return view('livewire.components.telegram.idx');
    }

    public function mount(){
        if(is_null(Auth::user())){
            return redirect()->route('arsys.home');
        }{

            if(Str::length(Auth::user()->sso) > 7){
                $this->programId = Auth::user()->staff->program_id;
            }elseif((Str::length(Auth::user()->sso) > 4) && ( Str::length(Auth::user()->sso) <= 7)){
                $this->programId = Auth::user()->student->program_id;
            }else{

            }
        }
    }
}
