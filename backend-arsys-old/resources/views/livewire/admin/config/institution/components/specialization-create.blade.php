<div class="row">
    <div class="col-md-12 offset-md-0 text-right">
        <div x-data="{addSpecialization : @entangle('addSpecialization') }">
            @if(!$addSpecialization)
                <x-adminlte-button class="btn btn-sm" wire:click="addSpecialization_AdminConfigInstitutionPage" label="Add specialization" theme="success" icon="fas fa-plus-circle"/>
            @endif
            <div x-show="addSpecialization">
                <div class="card card-online card-cyan">
                    <div class="card-header">
                        <div class="row">
                            <div class="col-md-11 offset-md-0 text-left">
                                <b>
                                    Add specialization
                                </b>
                            </div>
                            <div class="col-md-1 offset-md-0 text-right">
                                <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="addSpecialization_AdminConfigInstitutionPage">
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
                            <div class="col-md-5 text-left" >
                                <x-adminlte-select2 label="Head of study specialization" style="width: 100%" wire:model="headOfSpecializationCreate" id="headOfSpecializationCreate" name="headOfSpecializationCreate">
                                    <option default>Please select head of specialization</option>
                                    @foreach ($staffs as $index => $staff)
                                        <option value="{{$staff->id}}"><b>{{$staff->code}}</b>-{{$staff->first_name}} {{$staff->last_name}}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('headOfSpecializationCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>



                        {{-- Get staff list using paginated table --}}
                        {{--
                        <div class="row text-left">
                            <div class="col-md-7">
                                <x-adminlte-input placeholder="Responsible staff" value="responsibleNameCreate" wire:model="responsibleNameCreate" name="responsibleNameCreate" label="Responsible staff" style="width: 100%" disabled/>
                                @error('responsibleNameCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>
                        <hr>
                        <div class="row text-left">
                            <div class="col-md-12">
                                <livewire:admin.components.search.collect-staff :wire:key="'$responsiblePerson'">
                            </div>
                        </div>
                        --}}
                        <div class="row text-left">
                            <div class="col-md-3">
                                <x-adminlte-button   wire:click="saveSpecialization_ArSysAdminConfigInstiturionPage"
                                theme="success" icon="fa fa-save" class="btn btn-sm" label="Save specialization"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {

                $('#headOfSpecializationCreate').on('change', function (e) {
                    let data = $(this).val();
                    @this.set('headOfSpecializationCreate', data);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectHeadOfSpecializationCreate_Admin_ConfigInstitutionPage',()=>{
                    $('#headOfSpecializationCreate').select2('destroy');
                    $('#headOfSpecializationCreate').select2();
                });
            });
        </script>
    @endpush
</div>
