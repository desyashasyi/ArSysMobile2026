<div>
    <div class="card card-outline card-purple">
        <div class="card-header">
            <b>Final Defense room</b>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="text-right col-md-12">
                    <x-adminlte-button wire:click="addRoom" theme="success"
                        icon="fa fa-plus-circle" class="btn btn-xs btn-sm" label="Add room" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 offset-sm-0">
                    <div class="row">
                        <div class="text-left col-md-12">
                            @if($rooms->isNotEmpty())
                                <div class="table-responsive users-table">
                                    <table class="table table-sm data-table">
                                        <thead class="thead">
                                            <tr>
                                                <th width="5%">Id</th>
                                                <th width="25%">Schedule</th>
                                                <th width="25%">Examiner</th>
                                                <th width="35%">Applicants</th>
                                                <th class="text-right" width="10%"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            @foreach($rooms as $room)
                                                <tr>
                                                    <td>
                                                        P-{{$rooms->currentPage()}}
                                                    </td>
                                                    <td>
                                                        <span  style="cursor: pointer; color:green" wire:click="$emit('space_ArSysSpecializationEventApplicant', {{$room->id}}, 'Final-defense')">
                                                            <i  class="fa fa-xs fa-building" ></i>
                                                            <u>Space</u>

                                                        </span>
                                                        <br>
                                                        @if($room->space)
                                                            {{$room->space->description}}
                                                        @endif
                                                        <hr>
                                                        <span style="cursor: pointer; color:green" wire:click="$emit('session_ArSysSpecializationEventApplicant', {{$room->id}}, 'Final-defense')">
                                                            <i  class="fa fa-xs fa-clock" ></i>
                                                            <u>Session</u>
                                                        </span>
                                                        <br>
                                                        @if($room->session)
                                                            {{$room->session->time}}
                                                        @endif

                                                    </td>
                                                    <td>
                                                        <span wire:click="$emit('moderatorAndexaminer_ArSysSpecializationFinalDefense', {{$room->id}},'Moderator')" style="cursor: pointer;color:green">
                                                            <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                                            <u>Moderator</u>
                                                        </span>
                                                        <br>
                                                        @if(!is_null($room->moderator))
                                                            {{$room->moderator->first_name}} {{$room->moderator->last_name}}
                                                        @endif
                                                        <hr>
                                                        <span wire:click="$emit('moderatorAndexaminer_ArSysSpecializationFinalDefense', {{$room->id}},'Examiner')" style="cursor: pointer;color:green">
                                                            <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                                            <u>Examiner(s)</u>
                                                        </span>
                                                        <br>
                                                        @foreach($room->examiner as $index => $examiner)
                                                            {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                            <br>
                                                        @endforeach
                                                    </td>
                                                    <td>
                                                        @foreach($room->applicant as $index => $applicant)
                                                            @if($applicant->research->student->program_id != Auth::user()->staff->program->id)
                                                                <span style="color:gray">
                                                                    {{$index+1}}.
                                                                    {{$applicant->research->student->first_name}}
                                                                    {{$applicant->research->student->last_name}}
                                                                    ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                                </span>
                                                            @else
                                                                {{$index+1}}.
                                                                {{$applicant->research->student->first_name}}
                                                                {{$applicant->research->student->last_name}}
                                                                ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                            @endif
                                                            <br>
                                                        @endforeach
                                                    </td>

                                                    <td class="text-right">
                                                        <span wire:click="deleteRoom({{$room->id}})" style="color:red; cursor: pointer;">
                                                            <i class="fa fa-xs fa-times-circle"></i> delete
                                                        </span>
                                                    </td>

                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                                {{$rooms->render()}}
                            @endif
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 offset-sm-0">
                    @if($event->finaldefenseApplicant->contains('publish', null))
                        <span style="color:red">
                           There are {{$event->finaldefenseApplicant->where('publish', null)->count()}} applicants to be published. Please re-publish the schedule.
                        </span>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <livewire:specialization.event.components.space>
    <livewire:specialization.event.components.session>
    <livewire:specialization.event.components.final-defense-moderator-examiner>
</div>
