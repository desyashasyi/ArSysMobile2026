<?php

namespace App\Http\Livewire\Components\Telegram;

use App\Models\ArSys\TelegramId;
use Auth;
use Carbon\Carbon;
use Jantinnerezo\LivewireAlert\LivewireAlert;
use Livewire\Component;
use Telegram\Bot\Laravel\Facades\Telegram;

class Page extends Component
{
    use LivewireAlert;
    public $chatText;
    public function render()
    {
        $telegram = Telegram::getUpdates();

        foreach($telegram as $telegramMessage){
            if($telegramMessage->message){

                $splitMessage = explode(" ",$telegramMessage->message->text);

                if(array_key_exists(1, $splitMessage)){
                    if( $splitMessage[1]== Auth::user()->sso){
                        if(is_null(Auth::user()->telegram)){
                            TelegramId::create([
                                'user_id' => Auth::user()->id,
                                'telegram_chat_id' => $telegramMessage->message->from->id
                            ]);
                        }
                    }
                }
            }
        }
        return view('livewire.components.telegram.page', ['telegram' => $telegram]);
    }

    public function sendMessage(){
        //update telegram
        if(is_null(Auth::user()->telegram)){
            $this->alert('error', 'You don\'t have registered Telegram account',[
                'position' => 'top-end',
            ]);
        }else{
            if(strlen(Auth::user()->sso) > 7){
                $this->chatText = 'Dear...  '.Auth::user()->staff->code.', congratulation!! From now you will get notification from ArSysNG';
            }elseif(strlen(Auth::user()->sso) > 4 && strlen(Auth::user()->sso) <= 7){
                $this->chatText = 'Hi...  '.Auth::user()->student->first_name.' '.Auth::user()->student->last_name.', congratulation!! From now you will get notification from ArSysNG';
            }elseif(strlen(Auth::user()->sso) == 4){

            }
            Telegram::sendMessage([
                'chat_id' => Auth::user()->telegram->telegram_chat_id,
                'text' => $this->chatText,
            ]);
        }
    }

    public function resetAccount(){
        //dd(User::where('id', Auth::user()->id)->first());
        if(Carbon::parse(Auth::user()->telegram->created_at)->diffInDays(Carbon::now()) > 1){
            if(!is_null(Auth::user()->telegram)){
                TelegramId::where('user_id', Auth::user()->id)->delete();
            }
            $this->render();
        }
    }

    public function refresh(){
        $this->render();
    }
}
