<?php

namespace App\Http\Livewire\Administration\Research\Proposal;

use App\Models\ArSys\FacultyLetter;
use App\Models\ArSys\FacultyLetterBase;
use App\Models\ArSys\ProgramLetter;
use App\Models\ArSys\ProgramLetterBase;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchLetter;
use App\Models\ArSys\ResearchLetterBase;
use Livewire\Component;
use PDF;

class View extends Component
{
    protected $listeners = ['viewResearch_ArSysAdministrationResearchView', 'refresh_ArSysSpecializationResearchNewView' => '$refresh'];

    public $research;
    public $researchId;
    public $facultyNumber;
    public $facultyLetterDate;
    public $programNumber;
    public $programLetterDate;
    public $expireDate;
    public function render()
    {
        return view('livewire.administration.research.proposal.view');
    }

    public function viewResearch_ArSysAdministrationResearchView($researchId){
        $this->researchId = $researchId;
        $this->research = Research::where('id',  $researchId)->first();
        if($this->research->spvLetter){
            $this->facultyNumber = $this->research->spvLetter->faculty_letter_number;
            $this->facultyLetterDate = $this->research->spvLetter->faculty_letter_date_back;
            $this->programNumber = $this->research->spvLetter->program_letter_number;
            $this->programLetterDate = $this->research->spvLetter->program_letter_date_back;
            $this->expireDate = $this->research->spvLetter->expire_date_back;
        }
        $this->emit('reloadPickadayLetterDate');
    }
    public function printAssignment($researchId){
        $research = Research::find($researchId);
        $pdfContent = PDF::loadView('livewire.administration.research.proposal.print.assignment', ['research' => $research])->output();
        return response()->streamDownload(
            fn () => print($pdfContent),
            "SK TA:Skripsi ".$this->research->student->first_name." ".$this->research->student->last_name.".pdf"
        );
        /*return response()->streamDownload(function () {
            $pdf = App::make('dompdf.wrapper', $research);
            $pdf->loadView('livewire.program.research.proposal.print.assignment')
                ->setPaper('a4', 'portrait');
            echo $pdf->stream();
        }, 'test.pdf');
        */

    }

    public function saveLetter($researchId){
        $this->validate([
            'facultyNumber' => 'required',
            'facultyLetterDate' => 'required',
            'programNumber' => 'required',
            'programLetterDate' => 'required',
            'expireDate' => 'required',
        ]);
        if(is_null(ResearchLetter::where('research_id', $researchId)
            ->where('research_letter_base_id', ResearchLetterBase::where('code', 'SPV-TA')->first()->id)->first())){
                ResearchLetter::create([
                    'research_id' => $researchId,
                    'research_letter_base_id' => ResearchLetterBase::where('code', 'SPV-TA')->first()->id,
                    'faculty_letter_id' =>
                        FacultyLetter::where('faculty_id', $this->research->student->program->faculty->id)
                                    ->where('faculty_letter_base_id',FacultyLetterBase::where('code', 'SPV-TA')->first()->id)->first()->id,
                    'faculty_letter_number' => $this->facultyNumber,
                    'faculty_letter_date_back' => $this->facultyLetterDate,
                    'program_letter_id' => ProgramLetter::where('program_id', $this->research->student->program->id)
                                    ->where('program_letter_base_id',ProgramLetterBase::where('code', 'SPV-TA')->first()->id)->first()->id,
                    'program_letter_number' => $this->programNumber,
                    'program_letter_date_back' => $this->programLetterDate,
                    'expire_date_back' => $this->expireDate,
                ]);
        }else{
            ResearchLetter::update([
                'research_id' => $researchId,
                'research_letter_base_id' => ResearchLetterBase::where('code', 'SPV-TA')->first()->id,
                'faculty_letter_id' =>
                    FacultyLetter::where('faculty_id', $this->research->student->program->faculty->id)
                                ->where('faculty_letter_base_id',FacultyLetterBase::where('code', 'SPV-TA')->first()->id)->first()->id,
                'faculty_letter_number' => $this->facultyNumber,
                'faculty_letter_date_back' => $this->facultyLetterDate,
                'program_letter_id' => ProgramLetter::where('program_id', $this->research->student->program->id)
                                ->where('program_letter_base_id',ProgramLetterBase::where('code', 'SPV-TA')->first()->id)->first()->id,
                'program_letter_number' => $this->programNumber,
                'program_letter_date_back' => $this->programLetterDate,
                'expire_date_back' => $this->expireDate,
            ]);
        }
    }

    public function hydrate(){
        $this->emit('reloadPickadayLetterDate');
    }

}
