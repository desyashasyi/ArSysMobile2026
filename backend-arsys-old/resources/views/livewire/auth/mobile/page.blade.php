<div>
    <div class="row text-center"> 
        <div class="col-md-6 text-left">
            <i>To activate mobile feature, please enter your password</i>
        </div>
    </div>
    <hr>
    <div class="row text-center">
        <div class="col-md-4 text-left">
            <x-adminlte-input type="email" placeholder="{{$email}}" wire:model="email" name="email" label="Email" style="width: 100%" disabled/>
        
        </div>
    </div>

    <div class="row text-center">
        <div class="col-md-3 text-left">
            <x-adminlte-input wire:click="clear" type="password" placeholder="Type your password" wire:model="password" name="password" label="Password" style="width: 100%"/>
            @error('password') <span class="text-danger">{{ $message }}</span><br> @enderror
        </div>
    </div>

    <div class="row text-center">
        <div class="col-md-3 text-left">
            <x-adminlte-input type="password" placeholder="Retype your password" wire:model="retypePassword" name="retypePassword" label="Retype Password" style="width: 100%"/>
            @error('retypePassword') <span class="text-danger">{{ $message }}</span><br> @enderror
        </div>
    </div>
    <hr>
    <x-adminlte-button theme="success" class="btn btn-sm" icon="fa fa-save" wire:click="save" label="Save"/>

</div>
