<?php

namespace App\Http\Livewire\Program\Research\Proposal;

use App\Models\ArSys\Research;
use Auth;
use Livewire\Component;
use PDF;

class Page extends Component
{
    public $search;
    public function render()
    {
        $programId = null;
        if(Auth::user()->staff){
            $programId = Auth::user()->staff->program_id;
        }elseif(Auth::user()->sysrole){
            $programId = Auth::user()->sysrole->program_id;
        }
        $researchs = Research::whereHas('active')
            ->whereHas('student', function($query)use($programId){
                $query->where('program_id', $programId);
            })
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->orderBy('updated_at')
            ->paginate(10);
        //->get();
        if(!is_null($this->search)){
            $researchs = Research::whereHas('active')
            ->whereHas('student', function($query)use($programId){
                $query->where('program_id', $programId)
                    ->where('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%')
                    ->orwhere('number','like', '%'.$this->search.'%');
            })
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->sortBy('SIASPro', function($query){
                    $query->orderBy('status', 'DESC');
                })
            ->paginate(10);
        }
        return view('livewire.program.research.proposal.page', ['researchs' => $researchs]);
    }

    public function SIASApprove($researchId){
        $research = Research::find($researchId);
        if($research->SIASPro->status == 1){
            $research->SIASPro->update([
                'status' => null,
            ]);
        }else{
            $research->SIASPro->update([
                'status' => 1,
            ]);
        }
    }

    public function printAssignment($researchId){
        $research = Research::find($researchId);
        $pdfContent = PDF::loadView('livewire.program.research.proposal.print.assignment', ['research' => $research])->output();
        return response()->streamDownload(
            fn () => print($pdfContent),
            "filename.pdf"
        );
        /*return response()->streamDownload(function () {
            $pdf = App::make('dompdf.wrapper', $research);
            $pdf->loadView('livewire.program.research.proposal.print.assignment')
                ->setPaper('a4', 'portrait');
            echo $pdf->stream();
        }, 'test.pdf');
        */

    }
}
