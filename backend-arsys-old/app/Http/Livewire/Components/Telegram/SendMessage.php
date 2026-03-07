<?php

namespace App\Http\Livewire\Components\Telegram;

use App\Http\Livewire\Arsys\Components\Telegram\Throwable;
use App\Models\ArSys\TelegramId;
use App\Models\User;
use Livewire\Component;
use Telegram\Bot\Laravel\Facades\Telegram;

class SendMessage extends Component
{
    public $userId;
    public $text;
    protected $listeners =['sendMessage_ArSysComponentsTelegramSendMessage'];
    public function render()
    {
        return view('livewire.components.telegram.send-message');
    }

    public function sendMessage_ArSysComponentsTelegramSendMessage($userId, $text){
        if(User::find($userId)->telegram->telegram_blocked != 1){
            try
            {
                Telegram::sendMessage([
                    'chat_id' => User::find($userId)->telegram->telegram_chat_id,
                    'text' => $text,
                ]);

            }
            catch (\Exception $e)
            {
                Telegram::sendMessage([
                    'chat_id' => '764858393',
                    'text'    => 'There is error in the code for '. User::find($userId)->name,
                ]);
                TelegramId::where('user_id', User::find($userId)->id)->update([
                    'telegram_blocked' => 1,
                ]);
            }
            catch (Throwable $e)
            {
                Telegram::sendMessage([
                    'chat_id' => '764858393',
                    'text'    => 'Some one block the ArSysNG: '. User::find($userId)->name,
                ]);
                TelegramId::where('user_id', User::find($userId)->id)->update([
                    'telegram_blocked' => 1,
                ]);
            }
        }
    }
}
