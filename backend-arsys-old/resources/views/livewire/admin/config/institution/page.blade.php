
<div>
    <div wire:key="arsys.admin.config.research.page">
        @if($configs)
            <div class="row">
                <div class="col-md-12 text-left">
                    <div class="table-responsive users-table">
                        <table class="table table-sm data-table">
                            <thead class="thead">
                                <tr>
                                    <th width="5%">No.</th>
                                    <th width="30%">Code</th>
                                    <th width="45%">Description</th>
                                    <th width="10%">Status</th>
                                    <th class="text-right" width="10%">Action</th>

                                </tr>
                            </thead>
                            <tbody>
                                @foreach($configs as $index => $config)
                                    <tr>
                                        <td>
                                            {{$index+1}}.
                                        </td>
                                        <td>
                                            {{$config->data->code}}
                                        </td>
                                        <td>
                                            {{$config->data->description}}
                                        </td>
                                        <td>
                                            @if($config->status)
                                                <button wire:click="setInstitutionConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i></button>
                                            @else
                                                <button wire:click="setInstitutionConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i></button>
                                            @endif
                                        </td>
                                        <td class="text-right">
                                            @if(!$viewConfigIndex[$index])
                                                @if($config->status)
                                                    <x-adminlte-button   wire:click="expandViewConfig({{$index}}, {{$config->id}})"
                                                        theme="success" icon="fa fa-sm fa-eye" class="btn btn-xs" label="View"/>
                                                @endif
                                            @endif
                                        </td>

                                    </tr>
                                    @if($viewConfigIndex[$index])
                                    <tr>
                                        <td>
                                        </td>
                                        <td colspan="8" >
                                            <div class="row">
                                                <div class="col-md-12 text-left">
                                                    <div x-data="{enableSpecialization : @entangle('enableSpecialization') }">
                                                        <div x-show="enableSpecialization">
                                                            <livewire:admin.config.institution.specialization.page :wire:key="$config->id">
                                                        </div>
                                                    </div>
                                                    <div x-data="{enableStudyCompletion : @entangle('enableStudyCompletion') }">
                                                        <div x-show="enableStudyCompletion">
                                                            <livewire:admin.config.institution.study-completion.page :wire:key="$config->id">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                @endif
                                    {{--
                                    <div x-data="{enableSpecialization : @entangle('enableSpecialization') }">
                                        <div x-show="enableSpecialization">
                                            <tr>
                                                <td>

                                                </td>
                                                <td colspan="4">
                                                    <div class="card text-left">
                                                        <div class="card-body">
                                                            <div class="row">
                                                                <div class="col-md-12 text-left">
                                                                    <livewire:admin.config.institution.components.specialization-create :wire:key="'arsys.admin.config.instituion.page'">
                                                                </div>
                                                            </div>
                                                            @if($config->specialization->isNotEmpty())
                                                                <br>
                                                                <div class="row">
                                                                    <div class="col-md-12 text-left">
                                                                        <div class="table-responsive users-table">
                                                                            <table class="table table-sm data-table">
                                                                                <thead class="thead">
                                                                                    <tr>
                                                                                        <th width="5%">No.</th>
                                                                                        <th width="5%">Code</th>
                                                                                        <th width="50%">Description</th>
                                                                                        <th width="10%">Head</th>
                                                                                        <th width="20%" class="text-right" >Action</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <Tbody>
                                                                                    @foreach ($config->specialization as $index => $specialization)
                                                                                        <tr>
                                                                                            <td>
                                                                                                {{$index+1}}.
                                                                                            </td>
                                                                                            <td>
                                                                                                {{$specialization->code}}
                                                                                            </td>
                                                                                            <td>
                                                                                                {{$specialization->description}}
                                                                                            </td>
                                                                                            <td>
                                                                                                @if(!is_null($specialization->staff_id))
                                                                                                    {{$specialization->staff->code}}
                                                                                                @endif
                                                                                            </td>
                                                                                            <td class="text-right" >
                                                                                                <x-adminlte-button    wire:click="expandView({{$index}}, {{$specialization->id}})"
                                                                                                    theme="warning" icon="fa fa-xs fa-edit" class="btn btn-xs" label="Edit"/>
                                                                                                <x-adminlte-button   wire:click="deleteSpecialization_ArSysAdminConfigInstitutionPage({{$specialization->id}})"
                                                                                                    theme="danger" icon="fa fa-xs fa-trash" class="btn btn-xs" label="Delete"/>
                                                                                                    <x-adminlte-button   wire:click="loginAs({{$specialization->id}})"
                                                                                                        theme="warning" icon="fa fa-xs fa-sign-in" class="btn btn-xs" label="loginAs"/>
                                                                                            </td>
                                                                                        </tr>
                                                                                        @if($expandViewIndex[$index])
                                                                                            <tr>
                                                                                                <td></td>
                                                                                                <td colspan="4">
                                                                                                    <div x-data="{viewSpecialization : @entangle('viewSpecialization') }">
                                                                                                        <div x-show="viewSpecialization">
                                                                                                            <livewire:admin.config.institution.components.specialization-edit :specializationId="$specialization->id" :wire:key="'$specialization->id'">
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            @endif
                                                                                    @endforeach
                                                                                </Tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            @endif
                                                        </div>
                                                    </div>

                                                </td>
                                            </tr>
                                        </div>
                                    </div>
                                    --}}
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        @endif

</div>

