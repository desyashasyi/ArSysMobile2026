
<div>
    <div class="card" wire:key="'$specialization->id'">
        <div class="card-header bg-green">
            <div class="row">
                <div class="col-md-11 offset-md-0 text-left">
                    <b>
                        Edit specialization
                    </b>
                    {{-- Test data
                    {{$specializationId}}-{{$codeEdit}}-{{$descriptionEdit}}
                    <br>
                    {{$specialization}}
                    --}}
                </div>
                <div class="col-md-1 offset-md-0 text-right">
                    <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="$emitUp('editSpecializationDisable_ArSysAdminConfigInstitutionPage')">
                    </i>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row text-left">
                <div class="col-md-3">
                    <x-adminlte-input placeholder="code" wire:model="codeEdit" name="codeEdit" label="Code" style="width: 100%"/>
                    @error('codeEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
            </div>
            <div class="row text-left">
                <div class="col-md-7">
                    <x-adminlte-input placeholder="description" wire:model="descriptionEdit" name="descriptionEdit" label="Description of specialization" style="width: 100%"/>
                    @error('descriptionEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
            </div>
            <div class="row text-left">
                <div class="col-md-7">
                    <x-adminlte-input placeholder="Head of specialization" value="responsibleNameEdit" wire:model="responsibleNameEdit" name="responsibleNameEdit" label="Head of specialization" style="width: 100%" disabled/>
                    @error('responsibleNameEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
            </div>
            <hr>
            <div class="row text-left">
                <div class="col-md-12">
                    <livewire:admin.components.search.collect-staff :wire:key="'$responsiblePerson'">
                </div>
            </div>
            <div class="row text-left">
                <div class="col-md-3">
                    <x-adminlte-button   wire:click="updateSpecialization_ArSysAdminConfigInstitutionPage"
                    theme="success" icon="fa fa-save" class="btn btn-sm" label="Update"/>
                </div>
            </div>
        </div>

    </div>

</div>
