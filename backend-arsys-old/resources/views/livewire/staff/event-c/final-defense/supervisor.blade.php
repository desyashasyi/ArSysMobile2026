<div>
    @if($applicants->isNotEmpty())
        <br>
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <b>
                    <i style="color:black" class="fas fa-xs fa-user-graduate" ></i> Supervised students
                </b>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <tbody>
                            <tr>

                                <td width="45%">
                                    <span style="color:blue">
                                        <b>Name</b>
                                    </span>
                                </td>
                                <td width="35%">
                                    <span style="color:blue">
                                        <b>Space and Session</b>
                                    </span>

                                </td>
                                <td width="10%">
                                    <span style="color:blue">
                                        <b>Score</b>
                                    </span>
                                </td>
                            </tr>
                            @foreach($applicants as $index => $applicant)
                                <tr>

                                    <td width="45%">
                                        {{$index+1}}. {{$applicant->research->student->first_name}}
                                        {{$applicant->research->student->last_name}}
                                    </td>
                                    <td width="35%">
                                        @if($applicant->room && $applicant->room)
                                            @if($applicant->room->session)
                                                {{$applicant->room->session->time}}
                                            @endif |
                                            @if($applicant->room->space)
                                                {{$applicant->room->space->description}}
                                            @endif
                                        @endif
                                    </td>
                                    <td width="10%">
                                        @if(!is_null($applicant->research->supervisor))
                                            @foreach ($applicant->research->supervisor as $index => $supervisor)
                                                @if($supervisor->supervisor_id == Auth::user()->staff->id)
                                                    @if($supervisor->finaldefenseSupervisorPresence)
                                                        @if(is_null($supervisor->finaldefenseSupervisorPresence->score))
                                                            <span wire:click="$emit('score_ArSysStaffSupervisor_Seminar', {{$supervisor->id}}, {{$supervisor->finaldefenseSupervisorPresence->event_id}})" style="cursor: pointer; color:gray"><i class="fa fa-sm fa-check-circle"></i> NULL</span>
                                                        @else
                                                            <span wire:click="$emit('score_ArSysStaffSupervisor_Seminar', {{$supervisor->id}}, {{$supervisor->finaldefenseSupervisorPresence->event_id}})" style="cursor: pointer; color:green"><i class="fa fa-sm fa-check-circle"></i>
                                                            {{$supervisor->finaldefenseSupervisorPresence->score}}</span>
                                                        @endif
                                                    @endif
                                                @endif
                                            @endforeach
                                        @endif
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    @endif
    <livewire:staff.event.components.seminar-score-supervisor>
</div>
