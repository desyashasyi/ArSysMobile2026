<?php

namespace App\Http\Livewire\Specialization\Research\Components;

use App\Http\Livewire\Arsys\Specialization\Research\Components\TelegramId;
use App\Http\Livewire\Arsys\Specialization\Research\Components\Throwable;
use App\Models\ArSys\Research;
use App\Models\ArSys\ResearchRemark;
use App\Models\User;
use Auth;
use Livewire\Component;
use Telegram\Bot\Laravel\Facades\Telegram;

class Remark extends Component
{
    public $researchId;
    public $message;
    public $remarkEditor = false;
    public $remarks;
    public $showMore = false;
    protected $listeners = ['researchRemark_SpecializationResearchPage'];
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

        return view('livewire.specialization.research.components.remark');
    }

    public function researchRemark_SpecializationResearchPage($researchId){
        $this->researchId = $researchId;

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
        $research = Research::where('id', $this->researchId)->first();

        if(!is_null($research->student->user->telegram)){
            if($research->student->user->telegram->telegram_blocked != 1){
                try
                {
                    Telegram::sendMessage([
                        'chat_id' => $research->student->user->telegram->telegram_chat_id,
                        'text' => User::where('id', Auth::user()->id)->first()->staff->code.': '. strip_tags(str_replace('<p>', '<p style="margin:0">', $this->message)),
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
        $this->emit('setSummernoteMessageSpecializationRemark');
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
        if(ResearchRemark::where('id', $remarkId)->first()->discussant_id
            == Auth::user()->id){
                ResearchRemark::where('id', $remarkId)->delete();
        }
    }
}
