<?php

namespace App\Http\Livewire\Components\Research;

use App\Models\ArSys\ResearchRemark;
use Auth;
use Livewire\Component;
use Livewire\WithPagination;

class Remark extends Component
{
    public $researchId;
    public $message;
    public $remarkEditor = false;
    use WithPagination;
    protected $paginationTheme = 'bootstrap';
    public function render()
    {
        $remarks = ResearchRemark::where('research_id', $this->researchId)
            ->orderBy('created_at', 'DESC')
            ->paginate($perPage = 3, $columns = ['*'], $pageName = 'researchRemake');

        return view('livewire.components.research.remark', ['remarks' => $remarks]);
    }
    public function mount($researchId){
        $this->researchId = $researchId;
    }

    public function hydrate(){
        $this->emit('setSummernoteRemark');
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
        ///$this->message = '';
    }
    public function addRemark(){
        if(!$this->remarkEditor){
            $this->remarkEditor = true;
        }else{
            $this->remarkEditor = false;
        }
    }
    public function deleteMessage($remarkId){
        if(ResearchRemark::where('id', $remarkId)->first()->discussant_id
            == Auth::user()->id){
                ResearchRemark::where('id', $remarkId)->delete();
        }
    }
}
