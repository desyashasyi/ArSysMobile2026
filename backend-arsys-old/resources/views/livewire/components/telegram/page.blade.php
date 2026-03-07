<div>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="text-left card card-outline card-primary">
                    <div class="card-body">
                        <b>Telegram chatId registration</b>
                    </div>
                    <div class="card-body">
                        @if(is_null(Auth::user()->telegram))
                            For the purpose of system notification,
                            Please register your telegram account by sending message to
                            ArSys Notification Guy (ArSysNG). 
                            <br>
                            
                            You can do it by clicking
                            <a wire:click="refresh" target="_blank" href="https://t.me/ArSysNGBot?start={{Auth::user()->sso}}">register.</a> 
                            and click the start button at the Telegram app.
                            <br>
                            <i style="color:red">Beware, you should have access to Telegram Desktop or Mobile</i>
                            <hr>
                            If You already sent message by clicking register above, 
                            please <span class="fa fa-sm fa-refresh" style="cursor: pointer;color:blue" wire:click="resetAccount"> refresh the page</span>..
                        @else
                            Congratulation, your Telegram account has been registered.
                            <hr>
                            You can try to get notification from ArSysNG by clicking
                            <span class="fa fa-sm fa-paper-plane" style="cursor: pointer;color:blue" wire:click="sendMessage"> send message</span>.
                            <hr>
                            <div class="row bg-warning">
                                <div class="col-md-12">
                                    If You have registered your account more than 48 hours and You want to reset your Telegram account please click <i class="fa fa-sm fa-paper-plane" style="color: red; cursor: pointer;" wire:click="resetAccount"> <b>reset</b></i>.
                                </div>
                            </div>
                        @endif
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

