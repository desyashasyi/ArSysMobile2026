<div class="row">
    <div class="col-md-12 offset-md-0 text-right">
        <div x-data="{addStudyCompletion : @entangle('addStudyCompletion') }">
            @if(!$addStudyCompletion)
                <x-adminlte-button class="btn btn-sm" wire:click="addStudyCompletion_AdminConfigInstitutionPage" label="Add study completion team" theme="success" icon="fas fa-plus-circle"/>
            @endif
            <div x-show="addStudyCompletion">
                <div class="card">
                    <div class="card-header bg-cyan">
                        <div class="row">
                            <div class="col-md-11 offset-md-0 text-left">
                                <b>
                                    Add study completion section
                                </b>
                            </div>
                            <div class="col-md-1 offset-md-0 text-right">
                                <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="addStudyCompletion_AdminConfigInstitutionPage">
                                </i>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row text-left">
                            <div class="col-md-3">
                                <x-adminlte-input placeholder="code" wire:model="codeCreate" name="codeCreate" label="Code" style="width: 100%">
                                    <x-slot name="bottomSlot">
                                        <span class="text-sm text-gray">
                                           [Define the code of specialization]
                                        </span>
                                    </x-slot>
                                </x-adminlte-input>
                            </div>
                            <div class="col-md-9 text-left">
                                <x-adminlte-input placeholder="description" wire:model="descriptionCreate" name="descriptionCreate" label="Description" style="width: 100%">
                                    <x-slot name="bottomSlot">
                                        <span class="text-sm text-gray">
                                           [Define the code of specialization]
                                        </span>
                                    </x-slot>
                                </x-adminlte-input>
                            </div>
                        </div>
                        <div class="row text-left">
                            <div class="col-md-3 text-left">
                                @error('codeCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                            <div class="col-md- text-left">
                                @error('descriptionCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>


                        <div class="row text-left">
                            <div class="col-md-8">
                               Team staffs
                            </div>
                        </div>
                        <div class="row text-left">
                            <div class="col-md-8">
                               Staffs
                            </div>
                        </div>
                        <div class="row text-left">
                            <div class="col-md-6">
                                <livewire:admin.components.search.collect-staff :wire:key="'$responsiblePerson'">
                            </div>
                        </div>
                        <div class="row text-left">
                            <div class="col-md-3">
                                <x-adminlte-button   wire:click="saveStudiCompletion_ArSysAdminConfigInstitutionPage"
                                theme="success" icon="fa fa-save" class="btn btn-sm" label="Save specialization"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
