<div>
    <div wire:key="arsys.super-admin.config.program.components.program-create">
        <div class="row">
            <div class="col-md-12 offset-md-0 text-right">
                <div x-data="{addProgram : @entangle('addProgram') }">
                    @if(!$addProgram)
                        <div class="row">
                            <div class="col-md-12 text-right">
                            <x-adminlte-button   wire:click="addProgram_ArSysSAConfigProgramPage" theme="success" icon="fa fa-plus-circle" class="btn btn-sm" label="Add program"/>
                            </div>
                        </div>
                    @endif
                    <div x-show="addProgram">
                        <div class="row">
                            <div class="col-md-12 offset-md-0 text-left">
                                <div class="card">
                                    <div class="card-header bg-cyan">
                                        <div class="row">
                                            <div class="col-md-11 offset-md-0 text-left">
                                                <b>
                                                    Add study program
                                                </b>
                                            </div>
                                            <div class="col-md-1 offset-md-0 text-right">
                                                <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="addProgram_ArSysSAConfigProgramPage">
                                                </i>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <x-adminlte-input placeholder="code" wire:model="codeCreate" name="codeCreate" label="Code" style="width: 100%"/>
                                                @error('codeCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-3">
                                                <x-adminlte-input placeholder="abbreviation" wire:model="abbrevCreate" name="abbrevCreate" label="Abbreviation" style="width: 100%"/>
                                                @error('abbrevCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6" >
                                                <x-adminlte-input placeholder="Please write program study" wire:model="nameCreate" name="nameCreate" label="Name of program study" style="width: 100%"/>
                                                @error('nameCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-4" >
                                                <x-adminlte-select2 label="Level of study program" style="width: 100%" wire:model="levelCreate" id="levelCreate" name="levelCreate">
                                                    <option default>Please select the program level</option>
                                                    @foreach ($levels as $index => $level)
                                                        <option value="{{$level->id}}"><b>{{$level->code}}</b>-{{$level->name}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('levelCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-5" >
                                                <x-adminlte-select2 label="Head of study program" style="width: 100%" wire:model="headOfProgramCreate" id="headOfProgramCreate" name="headOfProgramCreate">
                                                    <option default>Please select head of study program</option>
                                                    @foreach ($staffs as $index => $staff)
                                                        <option value="{{$staff->id}}"><b>{{$staff->code}}</b>-{{$staff->first_name}} {{$staff->last_name}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('headOfProgramCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 offset-md-0 text-left">
                                                <x-adminlte-select2 label="Faculty" style="width: 100%" wire:model="facultyCreate" id="facultyCreate" name="facultyCreate">
                                                    <option default>Please select the faculty</option>
                                                    @foreach ($faculties as $index => $faculty)
                                                        <option value="{{$faculty->id}}"><b>{{$faculty->code}}</b>-{{$faculty->name}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('facultyCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-6 offset-md-0 text-left">
                                                <x-adminlte-select2 label="Cluster of program" style="width: 100%" wire:model="clusterCreate" id="clusterCreate" name="clusterCreate">
                                                    <option default>Please select the cluster</option>
                                                    @foreach ($clusters as $index => $cluster)
                                                        <option value="{{$cluster->id}}"><b>{{$cluster->code}}</b>-{{$cluster->name}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('clusterCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                                        <hr>
                                        <div class="row">

                                            <div class="col-md-6 offset-md-0 text-left">
                                                @if(!$addFaculty)
                                                    <u style="color: green; cursor: pointer;" wire:click="addFaculty_ArSysSAConfigProgramPage"><i class="fa fa-sm fa-plus-circle" >
                                                    </i>&nbsp;Add faculty</u>
                                                @endif
                                            </div>
                                            <div class="col-md-6 offset-md-0 text-left">
                                                @if(!$addCluster)
                                                    <u style="color: green; cursor: pointer;" wire:click="addCluster_ArSysSAConfigProgramPage"><i class="fa fa-sm fa-plus-circle" >
                                                    </i>&nbsp;Add cluster</u>
                                                @endif
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-12 offset-md-0 justify-content-right">
                                                <div class="row">
                                                    <div class="col-md-8 offset-md-0 text-left">
                                                        <div x-data="{addCluster : @entangle('addCluster') }">
                                                            <div x-show="addCluster">
                                                                <div class="row">
                                                                    <div class="col-md-12 offset-md-0 text-right">
                                                                        <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="addCluster_ArSysSAConfigProgramPage">
                                                                        </i>
                                                                    </div>
                                                                </div>
                                                                <div class="card">
                                                                    <div class="card-header bg-cyan">
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="row">
                                                                            <div class="col-md-12 offset-md-0 text-left">
                                                                                <u>
                                                                                    <b>
                                                                                        Add Cluster
                                                                                    </b>
                                                                                </u>
                                                                            </div>
                                                                        </div>
                                                                        <hr>
                                                                        <div class="row">
                                                                            <div class="col-md-4">
                                                                                <x-adminlte-input placeholder="code" wire:model="codeClusterCreate" name="codeClusterCreate" label="Code" style="width: 100%"/>
                                                                                @error('codeClusterCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                                                            </div>
                                                                            <div class="col-md-8">
                                                                                <x-adminlte-input placeholder="Name of cluster" wire:model="nameClusterCreate" name="nameClusterCreate" label="Name" style="width: 100%"/>
                                                                                @error('nameClusterCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                                                            </div>
                                                                        </div>
                                                                        <hr>
                                                                        <div class="row">
                                                                            <div class="col-md-3">
                                                                                <x-adminlte-button   wire:click="saveCluster_ArSysSAConfigProgramPage"
                                                                                theme="success" icon="fa fa-save" class="btn btn-sm" label="Save cluster"/>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div x-data="{addFaculty : @entangle('addFaculty') }">
                                                            <div x-show="addFaculty">
                                                                <div class="row">
                                                                    <div class="col-md-12 offset-md-0 text-right">
                                                                        <i style="color: black; cursor: pointer;" class="fa fa-sm fa-times-circle" wire:click="addCluster_ArSysSAConfigProgramPage">
                                                                        </i>
                                                                    </div>
                                                                </div>
                                                                <div class="card">
                                                                    <div class="card-header bg-cyan">

                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="row">
                                                                            <div class="col-md-11 offset-md-0 text-left">
                                                                                <u>
                                                                                    <b>
                                                                                        Add Faculty
                                                                                    </b>
                                                                                </u>
                                                                            </div>
                                                                        </div>
                                                                        <hr>
                                                                        <div class="row">
                                                                            <div class="col-md-4">
                                                                                <x-adminlte-input placeholder="code" wire:model="codeFacultyCreate" name="codeFacultyCreate" label="Code" style="width: 100%"/>
                                                                                @error('codeFacultyCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                                                            </div>
                                                                            <div class="col-md-8">
                                                                                <x-adminlte-input placeholder="Name of faculty" wire:model="nameFacultyCreate" name="nameFacultyCreate" label="Name" style="width: 100%"/>
                                                                                @error('nameFacultyCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                                                            </div>
                                                                        </div>
                                                                        <hr>
                                                                        <div class="row">
                                                                            <div class="col-md-3">
                                                                                <x-adminlte-button   wire:click="saveFaculty_ArSysSAConfigProgramPage"
                                                                                theme="success" icon="fa fa-save" class="btn btn-sm" label="Save faculty"/>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <br>

                                        @if(!$addCluster && !$addFaculty)
                                            <x-adminlte-button   wire:click="saveProgram_ArSysSAConfigProgramPage" theme="success" icon="fa fa-save" class="btn btn-sm" label="Save program"/>
                                        @endif

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br>
        <div class="row">
            <div class="col-md-12">
                @if($programs->isNotEmpty())
                    <div class="row">
                        <div class="col-md-3 offset-md-0">
                            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search program">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-left">
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <thead class="thead">
                                        <tr>
                                            <th width="5%">No</th>
                                            <th width="10%">Code</th>
                                            <th width="30%">Description</th>
                                            <th width="10%">Head</th>
                                            <th width="10%">Level</th>
                                            <th width="10%">Cluster</th>
                                            <th width="10%">Faculty</th>
                                            <th width="15%" class="text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($programs as $index => $program)
                                        <tr>
                                            <td>
                                                {{$index+1}}.
                                            </td>
                                            <td>
                                                {{$program->code}}
                                            </td>
                                            <td>
                                                {{$program->abbrev}}-{{$program->name}}
                                            </td>
                                            <td>
                                                @if(!is_null($program->staff_id))
                                                    {{$program->staff->code}}
                                                @endif
                                            </td>
                                            <td>
                                                @if(!is_null($program->level))
                                                    {{$program->level->name}}
                                                @endif
                                            </td>

                                            <td>
                                                @if(!is_null($program->cluster))
                                                    {{$program->cluster->data->code}}
                                                @endif
                                            </td>
                                            <td>
                                                @if(!is_null($program->faculty))
                                                    {{$program->faculty->code}}
                                                @endif
                                            </td>
                                            <td class="text-right">
                                                @if(!$expandViewIndex[$index])
                                                    <x-adminlte-button   wire:click="expandView({{$index}}, {{$program->id}})"
                                                        theme="warning" icon="fa fa-xs fa-edit" class="btn btn-xs" label="Edit"/>
                                                @endif
                                                <x-adminlte-button   wire:click="loginAs({{$program->id}})"
                                                    theme="info" icon="fa fa-xs fa-user" class="btn btn-xs" label="Login"/>
                                            </td>
                                        </tr>
                                        @if($expandViewIndex[$index])
                                            <tr>
                                                <td>

                                                </td>
                                                <td colspan="6">
                                                    <div x-data="{editProgram : @entangle('editProgram') }">
                                                        <div x-show="editProgram">
                                                            <livewire:super-admin.config.program.components.program-edit :programId="$program->id" :wire:key="'$program->id'">
                                                        </div>
                                                    </div>
                                                </td>
                                                <td></td>
                                            </tr>
                                        @endif
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                            {{$programs->render()}}
                        </div>
                    </div>
                @endif
            </div>
        </div>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#clusterCreate').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('clusterCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectCluster_SA_ProgramPage',()=>{
                    $('#clusterCreate').select2('destroy');
                    $('#clusterCreate').select2();
                });

                $('#facultyCreate').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('facultyCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectFaculty_SA_ProgramPage',()=>{
                    $('#facultyCreate').select2('destroy');
                    $('#facultyCreate').select2();
                });

                $('#levelCreate').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('levelCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectLevel_SA_ProgramPage',()=>{
                    $('#levelCreate').select2('destroy');
                    $('#levelCreate').select2();
                });

                $('#headOfProgramCreate').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('headOfProgramCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectHeadOfProgramCreate_SA_ProgramPage',()=>{
                    $('#headOfProgramCreate').select2('destroy');
                    $('#headOfProgramCreate').select2();
                });
            });
        </script>
    @endpush
</div>

