<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Models\ArSys\Research;
use Livewire\Component;

class Similarity extends Component
{
    public $result;
    public $similarTitle;
    public function render()
    {
        return view('livewire.specialization.research.components.similarity');
    }

    public function mount($researchId){
        $comparison = new \Atomescrochus\StringSimilarities\Compare();
        $researchTitle = Research::find($researchId)->title;
        foreach(Research::all() as $research){
            $this->result = $comparison->all($researchTitle, $research->title);
            if($this->result['similar_text'] > 50.0 && $research->id != $researchId){
                dd($this->similarTitle, $this->result);
            }
        }

    }
}
