<?php

namespace App\Http\Livewire\Specialization\Research\BeingReviewed;
use App\Http\Livewire\Arsys\Specialization\Research\BeingReviewed\TelegramId;
use App\Http\Livewire\Arsys\Specialization\Research\BeingReviewed\Throwable;
use App\Models\ArSys\Program;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchSupervisor;
use App\Models\ArSys\ResearchType;
use Auth;
use Carbon\Carbon;
use Livewire\Component;
use Livewire\WithPagination;
use Telegram\Bot\Laravel\Facades\Telegram;

class Page extends Component
{
    public $search;
    public $expandViewIndex = [];
    public $viewIndex = null;
    public $tempIndex = null;
    protected $paginationTheme = 'bootstrap';
    public $pageName = 'researchPage';
    public $pageNumber = null;
    public $viewResearch = false;
    use WithPagination;
    protected $listeners = ['refresh_ArSysSpecializationResearchPage' => '$refresh',
                            'closeView_ArSysSpecializationResearchPage'];

    public function render()
    {
        $researches = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('review')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->get();
        $this->researchTypes = ResearchType::where('program_id', Auth::user()->staff->program_id)
            ->whereHas('data',function($query){
                $query->where('level_id', Program::find(Auth::user()->staff->program_id)->level_id);
            })
            ->get();

        $researchs = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('review',)
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->paginate($perPage = 10, $columns = ['*'], $pageName = 'researchProposalPage');

        if($this->search){
            $researchs = Research::whereHas('student', function($query){
                return $query->where('number','like', '%'.$this->search.'%')
                    ->orwhere('first_name','like', '%'.$this->search.'%')
                    ->orwhere('last_name','like', '%'.$this->search.'%')
                    ->where('program_id', Auth::user()->staff->program_id);
            })
            ->whereHas('review')
            ->orderBy('type_id', 'DESC')
            ->orderBy('student_id', 'ASC')
            ->orderBy('milestone_id', 'ASC')
            ->paginate(1);
        }
        if($this->pageNumber != $researchs->currentPage()){
            foreach($researchs as $index => $research){
                $this->expandViewIndex[$index] = null;
            }
            $this->pageNumber = $researchs->currentPage();
            $this->tempIndex = $researchs->count()+1;
            $this->viewIndex = $researchs->count()+1;
        }
        if($this->tempIndex != $this->viewIndex){
            $this->expandViewIndex[$this->viewIndex] = 1;
            $this->expandViewIndex[$this->tempIndex] = 0;
            $this->tempIndex = $this->viewIndex;
        }else{
            if($this->viewResearch == true){
                $this->expandViewIndex[$this->viewIndex] = 1;
            }
        }
        return view('livewire.specialization.research.being-reviewed.page', ['researchs' => $researchs]);
    }

    public function mount(){
        $this->viewResearch = false;
    }

    public function expandView($viewIndex, $researchId){
        $this->viewResearch = true;
        $this->viewIndex = $viewIndex;
        $this->expandViewIndex[$this->viewIndex] = 1;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }
    public function closeView_ArSysSpecializationResearchPage(){
        $this->viewResearch = false;
        $this->expandViewIndex[$this->viewIndex] = 0;
        $this->expandViewIndex[$this->tempIndex] = 0;
    }

    public function unAssign($supervisorId){
        ResearchSupervisor::find($supervisorId)->delete();
    }

    public function sendTelegramMessage(){
        $researchs = Research::whereHas('student', function($query){
            return $query->where('program_id', Auth::user()->staff->program_id);
        })
        ->whereHas('review')
        ->orderBy('student_id', 'ASC')
        ->orderBy('milestone_id', 'ASC')
        ->get();
        foreach($researchs as $research){
            if(!is_null($research->student->user->telegram)){
                if($research->student->user->telegram->telegram_blocked != 1){
                    try
                    {
                        Telegram::sendMessage([
                            'chat_id' => $research->student->user->telegram->telegram_chat_id,
                            'text' => 'Hi... '.$research->student->first_name.', This is a reminder that the review process has been ongoing for '.Carbon::parse($research->review->created_at)->diffInDays(Carbon::now()).' days since the review appointment. Make sure that you have contacted the lecturer appointed as reviewer, and intensively carry out the process until a decision is reached whether your proposal is accepted or rejected.',
                        ]);

                    }
                    catch (\Exception $e)
                    {
                        Telegram::sendMessage([
                            'chat_id' => '764858393',
                            'text'    => 'There is error in the code for '. $research->student->first_name,
                        ]);
                        TelegramId::where('user_id', $research->student->user->id)->update([
                            'telegram_blocked' => 1,
                        ]);
                    }
                    catch (Throwable $e)
                    {
                        Telegram::sendMessage([
                            'chat_id' => '764858393',
                            'text'    => 'Some one block the ArSysNG: '. $research->student->first_name,
                        ]);
                        TelegramId::where('user_id', $research->student->user->id)->update([
                            'telegram_blocked' => 1,
                        ]);
                    }
                }

            }

            foreach($research->reviewer as $reviewer){
                if(!is_null($reviewer->staff->user)){
                    if(!is_null($reviewer->staff->user->telegram)){
                        if($reviewer->staff->user->telegram->telegram_blocked != 1){
                            try {

                                Telegram::sendMessage([
                                    'chat_id' => $reviewer->staff->user->telegram->telegram_chat_id,
                                    'text' => 'Dear '.$reviewer->staff->code.', This is a reminder that the review process for research proposal of '.$research->student->first_name.' has been ongoing for '.Carbon::parse($research->review->created_at)->diffInDays(Carbon::now()).' days since the review appointment. Please submit the decision through ArSys review menu, or contact the head of specialization by Whatsapp message',
                                ]);

                            }
                            catch (\Exception $e)
                            {
                                Telegram::sendMessage([
                                    'chat_id' => '764858393',
                                    'text'    => 'There is error in the code for '. $reviewer->staff->code,
                                ]);
                                TelegramId::where('user_id', $research->student->user->id)->update([
                                    'telegram_blocked' => 1,
                                ]);
                            }
                            catch (Throwable $e)
                            {
                                Telegram::sendMessage([
                                    'chat_id' => '764858393',
                                    'text'    => 'Some one block the ArSysNG: '. $reviewer->staff->code,
                                ]);
                                TelegramId::where('user_id', $research->student->user->id)->update([
                                    'telegram_blocked' => 1,
                                ]);
                            }
                        }
                    }
                }
            }
        }
    }
}
