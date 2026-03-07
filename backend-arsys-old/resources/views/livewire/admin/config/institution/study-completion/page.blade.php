<div>
    <div class="row">
        <div class="text-left col-md-12">

            <div x-data="{enableStudyCompletion : @entangle('enableStudyCompletion') }">
                <div x-show="enableStudyCompletion">
                    {{--
                    <br>
                    <livewire:admin.config.institution.study-completion.create>
                    <br>
                    --}}
                    @if($studyCompletions->isNotEmpty())
                    <div class="row">
                        <div class="text-left col-md-12">
                            {{$studyCompletions}}
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <thead class="thead">
                                        <tr>
                                            <th width="5%">No.</th>
                                            <th width="5%">Code</th>
                                            <th width="45%">Description</th>
                                            <th width="30%">Team</th>
                                            <th class="text-right" width="15%">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach ($studyCompletions as $index => $studyCompletion)
                                            <tr>
                                                <td>
                                                    {{$index+1}}.
                                                </td>
                                                <td>
                                                    {{$studyCompletion->base->code}}
                                                </td>
                                                <td>
                                                    {{$studyCompletion->base->description}}
                                                </td>
                                                <td >
                                                    @foreach($studyCompletion->team as $team)
                                                        {{$team->staff->first_name}} {{$team->staff->last_name}}
                                                        <i style="cursor: pointer; color:red" class="fa fa-xs fa-user-minus"
                                                        wire:click="delete({{$team->id}})">
                                                        </i>
                                                        <br>
                                                    @endforeach

                                                </td>
                                                <td class="text-right">
                                                    @if(!$viewStudyCompletionIndex[$index])
                                                        <x-adminlte-button   wire:click="addTeam({{$index}}, {{$studyCompletion->id}})"
                                                        theme="success" icon="fa fa-sm fa-user-plus" class="btn btn-xs" label="Add team"/>
                                                    @endif
                                                </td>
                                                {{--
                                                <td class="text-right">
                                                    <x-adminlte-button   wire:click="editStudyCompletion({{$index}}, {{$studyCompletion->id}})"
                                                        theme="warning" icon="fa fa-xs fa-edit" class="btn btn-xs" label="Edit"/>

                                                        <x-adminlte-button   wire:click="deleteStudyCompletion({{$studyCompletion->id}})"
                                                        theme="danger" icon="fa fa-xs fa-trash" class="btn btn-xs" label="Delete"/>
                                                </td>
                                                --}}
                                            </tr>
                                            @if($viewStudyCompletionIndex[$index])
                                                <tr>
                                                    <td colspan="2">
                                                    </td>
                                                    <td colspan="3" >
                                                        <div class="row">
                                                            <div class="text-left col-md-12">
                                                                <div x-data="{enableStudyCompletion : @entangle('enableStudyCompletion') }">
                                                                    <div x-show="enableStudyCompletion">
                                                                        <div class="text-left card">
                                                                            <div class="card-header bg-info">
                                                                                <div class="row">
                                                                                    <div class="text-right col-md-12">
                                                                                        <i class="fa fa-times-circle" wire:click="closeView" style="color: black; cursor:pointer" ></i>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <livewire:admin.components.search.collect-staff :wire:key="'$responsiblePerson'">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            @endif

                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        {{$studyCompletions->links()}}
                    @endif
                </div>
                <div x-show="!enableStudyCompletion">
                    <i style="color: red">The final completion is disabled</i>
                </div>
            </div>
        </div>
    </div>
</div>
