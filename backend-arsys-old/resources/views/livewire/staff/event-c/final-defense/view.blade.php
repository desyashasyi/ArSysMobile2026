<div>
    <div class="row">
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                <div class="card-body">
                    @if($finalDefenseRooms->isNotEmpty())
                        @foreach($finalDefenseRooms as $room)
                            @if(!is_null($room))
                                <div class="row">
                                    <div class="col-md-12 offset-sm-0">
                                        @if($room->space)
                                            &nbsp;<b><i  class="fa fa-xs fa-building" style="color:green" ></i>
                                            Space: </b> {{$room->space->description}}
                                        @endif
                                        @if($room->session)
                                            <b><i  class="fa fa-xs fa-clock" style="color:green" ></i>
                                            Session: </b> {{$room->session->time}}
                                        @endif
                                    </div>
                                </div>
                                <br>
                                <div class="table-responsive users-table">
                                    <table class="table table-sm data-table">
                                        <tbody>
                                            <tr>
                                                <td width="45%">
                                                    <i style="color:purple" class="fas fa-xs fa-user-circle" ></i>
                                                    <span style="color:purple">
                                                        <b>Moderator and Examiner</b>
                                                    </span>
                                                </td>
                                                <td width="45%">
                                                    <i style="color:purple" class="fas fa-xs fa-user-graduate" ></i>
                                                    <span style="color:purple">
                                                        <b>Participants</b>
                                                    </span>
                                                </td>
                                                <td width="10%">
                                                    <span style="color:purple">
                                                        <b>Score</b>
                                                    </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="45%">
                                                    @foreach($room->examiner as $index => $examiner)
                                                        @if($room->moderator->id == Auth::user()->staff->id)
                                                            @if($examiner->finaldefenseExaminerPresence->isEmpty())
                                                                <i wire:click="examinerPresence({{$examiner->id}}, {{$room->id}})" style="color:gray; cursor: pointer;" class="fa fa-check-circle"></i>
                                                            @else
                                                                <i wire:click="examinerUnPresence({{$examiner->id}}, {{$room->id}})" style="color:green; cursor: pointer;" class="fa fa-check-circle"></i>
                                                            @endif
                                                        @else
                                                            @if($examiner->finaldefenseExaminerPresence->isEmpty())
                                                                <i style="color:gray; " class="fa fa-check-circle"></i>
                                                            @else
                                                                <i style="color:green; " class="fa fa-check-circle"></i>
                                                            @endif
                                                        @endif
                                                        @if($room->moderator->id == Auth::user()->staff->id)
                                                            <span  style="cursor: pointer; color:green" wire:click="assignModerator({{$examiner->staff->id}}, {{$room->id}})">
                                                                <u> {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}</u>
                                                            </span>
                                                        @else
                                                            {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                        @endif
                                                        @if($room->moderator->id == $examiner->staff->id)
                                                            (Moderator)
                                                        @endif
                                                        <br>
                                                    @endforeach
                                                </td>
                                                <td width="45%">
                                                    @foreach($room->applicant as $index => $applicant)
                                                        {{$index+1}}.
                                                        {{$applicant->research->student->first_name}}
                                                        {{$applicant->research->student->last_name}}
                                                        ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                        <br>
                                                    @endforeach
                                                </td>
                                                <td width="10%">
                                                    @if(!is_null($examinerPresence))
                                                        @foreach($examinerPresence as $presence)
                                                            @if(is_null($presence->score))
                                                                <span wire:click="$emit('seminarScore_ArSysStaffExaminer', {{$presence->id}})" style="cursor: pointer;color:gray"><i class="fa fa-sm fa-check-circle"></i> NULL</span>
                                                            @elseif($presence->score == -1)
                                                                -
                                                            @else
                                                                <span wire:click="$emit('seminarScore_ArSysStaffExaminer', {{$presence->id}})" style="cursor: pointer;color:green"><i class="fa fa-sm fa-check-circle"></i> {{$presence->score}}</span>
                                                            @endif
                                                            <br>
                                                        @endforeach
                                                    @endif
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 offset-sm-0">
                                        @if($room->moderator_id == Auth::user()->staff->id)
                                            <i style="color:red">
                                                Please click
                                                <i style="color:gray;" class="fa fa-check-circle"></i>
                                                for enabling score submission.
                                            </i>
                                            <br>
                                            <i style="color:red">
                                                Please click on examiner name to change the moderator.
                                            </i>
                                        @endif
                                    </div>
                                </div>

                            @endif
                        @endforeach
                        {{--{{$finalDefenseRooms->render()}}--}}

                        <div class="row">
                            <div class="col-md-10 offset-sm-0">
                                <livewire:staff.event.final-defense.supervisor :eventId="$eventId" :wire:key="'supervisor-'.$eventId">
                            </div>
                        </div>
                    @else
                        No applicant data as examiner
                    @endif
                    @if($finalDefenseRooms->isEmpty())
                        <div class="row">
                            <div class="col-md-10 offset-sm-0">
                                <livewire:staff.event.final-defense.supervisor :eventId="$eventId" :wire:key="'supervisor-'.$eventId">
                            </div>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
    <livewire:staff.event.components.seminar-score>
</div>
