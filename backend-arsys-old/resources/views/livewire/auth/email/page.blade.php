<div>
    <div class="row">
        <div class="col-md-3">
        
        </div>
        <div class="col-md-6">
            <div class="card card-outline card-warning">
                <div class="card-header">
                    Please register email@upi.edu
                </div>
                <div class="card-body">
                    <x-adminlte-input type="email" wire:model="email" name="ifLabel" label="Email"
                                        placeholder="email@upi.edu" />
                                    @error('email')
                                        <span class="text-danger">{{ $message }}</span> <br>
                                    @enderror
                    <x-adminlte-input wire:model="sso" name="ifLabel" label="SSO UPI"
                                    placeholder="Please provide UPI's SSo" disabled/>
                                    @error('sso')
                                        <span class="text-danger">{{ $message }}</span> <br>
                                    @enderror
                    <br>
                    <x-adminlte-button wire:click="save" theme="success" label="Save" class="btn-sm"
                    icon="fas fa-save" />
                </div>
            </div>
        </div>
        <div class="col-md-3">
           
        </div>
    </div>
</div>
