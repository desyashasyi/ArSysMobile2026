<?php

namespace App\Http\Livewire\Student\Research\Components;

use App\Models\ArSys\ResearchRemark;
use Auth;
use Livewire\Component;

class Remark extends Component
{
    public $researchId;
    public $message;
    public $remarkEditor = false;
    public $remarks;
    public $showMore;
    public function render()
    {
        if($this->researchId){
            $this->remarks = ResearchRemark::where('research_id', $this->researchId)->take(3)
            ->orderBy('created_at', 'DESC')->get();
            if($this->showMore){
                $this->remarks = ResearchRemark::where('research_id', $this->researchId)
                ->orderBy('created_at', 'DESC')->get();
            }
        }

        return view('livewire.student.research.components.remark');
    }

    public function mount(){
        $this->remarkEditor = false;
    }

    public function save(){
        $this->validate([
            'message' => 'required',
        ]);
        ResearchRemark::create([
            'discussant_id' => Auth::user()->id,
            'research_id' => $this->researchId,
            'message' => str_replace('<p>', '<p style="margin:0">', $this->message),
        ]);
        $this->addRemark();
        //.replace('<p>', '<p style="margin:0">')
    }

    public function addRemark(){
        if(!$this->remarkEditor){
            $this->remarkEditor = true;
        }else{
            $this->remarkEditor = false;
        }
    }
    public function showMore(){
        if(!$this->showMore){
            $this->showMore = true;
        }else{
            $this->showMore = false;
        }
    }

    public function deleteMessage($remarkId){
        ResearchRemark::where('id', $remarkId)->delete();
    }
    public function editMessage(){

    }
}
