<div>
    @if(is_null($addProgram))
        <div class="row">
            <div class="col-md-12 text-right">
                <x-adminlte-button class="btn btn-sm" wire:click="addProgram" icon="fas fa-sm fa-plus-circle" label="Add program" theme="success" />
            </div>
        </div>
    @endif
    @if(!is_null($addProgram))

        <div class="card card-online card-primary">
            <div class="card-header">
                <div class="row">
                    <div class="col-md-10">
                        <b><i>Add Program Study</i></b>
                    </div>
                    <div class="col-md-2 text-right">
                        <x-adminlte-button class="btn btn-sm" wire:click="save" icon="fas fa-sm fa-disk" label="Save" theme="success" />
                        <x-adminlte-button class="btn btn-sm" wire:click="addProgram" icon="fas fa-sm fa-ban" theme="danger" />
                    </div>
                </div>

            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <x-adminlte-input name="code" wire:model="code" label="Code" style="width: 100%">
                            <x-slot name="bottomSlot">
                                <span class="text-sm text-gray">
                                    [example: E045]
                                </span>
                            </x-slot>
                        </x-adminlte-input>
                        @error('code') <span class="text-xs text-danger">{{ $message }}</span><br> @enderror
                    </div>
                    <div class="col-md-3">
                        <x-adminlte-input name="code" wire:model="code" label="Abbrev" style="width: 100%"/>
                        @error('code') <span class="text-xs text-danger">{{ $message }}</span><br> @enderror
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <x-adminlte-input name="description" wire:model="description" label="Description" style="width: 100%"/>
                        @error('description') <span class="text-xs text-danger">{{ $message }}</span><br> @enderror
                    </div>
                    <div class="col-md-6">
                        <x-adminlte-input name="descriptionEng" wire:model="descriptionEng" label="Description in English" style="width: 100%"/>
                        @error('descriptionEng') <span class="text-xs text-danger">{{ $message }}</span><br> @enderror
                    </div>
                </div>
                <div class="row">

                </div>

            </div>
        </div>

    @endif
    <hr>
    <div class="row">
        <div class="col-md-12">
            <livewire:data.programs-table />
        </div>
    </div>

</div>
