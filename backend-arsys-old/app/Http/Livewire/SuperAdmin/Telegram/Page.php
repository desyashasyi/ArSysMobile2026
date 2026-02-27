<?php

namespace App\Http\Livewire\SuperAdmin\Telegram;

use App\Models\ArSys\TelegramId;
use App\Models\User;
use Livewire\Component;

class Page extends Component
{
    public function render()
    {

        return view('livewire.super-admin.telegram.page');
    }
    public function mount(){
        /*foreach(User::all() as $user){
            if(!is_null($user->telegram_chat_id)){
                TelegramId::create([
                    'user_id' => $user->id,
                    'telegram_chat_id' => $user->telegram_chat_id,
                ]);
            }
        }*/

    }

}
