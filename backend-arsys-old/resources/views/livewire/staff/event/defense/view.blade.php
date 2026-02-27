<div>
    <div class="row">
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                <div class="card-body">
                    @if($eventApplicants->isNotEmpty())
                        <div class="table-responsive users-table">
                            <table class="table table-sm data-table">
                                <thead class="thead">
                                    <tr>
                                        <th class="bg-orange" width="1%"></th>
                                        <th width="8%">No</th>
                                        <th width="25%">Student</th>
                                        <th width="10%" class="text-center">SPV(s)</th>
                                        <th width="15%" class="text-left">EX(s)</th>
                                        <th width="29%" class="text-left">
                                            Session and Space

                                        </th>
                                        <th class="text-right" width="10%">Score</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @php($counter=0)
                                    @foreach ($eventApplicants as $index => $applicant)
                                        @if($applicant->event_id == $eventId)
                                            @if($index%2 == 0)
                                                <tr class="bg-light">
                                            @else
                                                <tr>
                                            @endif
                                                <td class="bg-orange" width="1%"></td>
                                                <td>
                                                    @php($counter++)
                                                    {{$counter}}
                                                </td>
                                                <td>
                                                    @if($applicant->research->student->program != null)
                                                        {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                                    @endif
                                                    <br>
                                                    {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                                </td>
                                                <td class="text-center">
                                                    @if($applicant->research->supervisor != null)
                                                        @forelse ($applicant->research->supervisor as $supervisor)

                                                            {{$supervisor->staff->code}}

                                                            <br>
                                                        @empty
                                                        @endforelse
                                                    @endif
                                                </td>
                                                <td class="text-left">
                                                    @if(!is_null($applicant->research->predefenseApplied->defenseExaminer))
                                                        @foreach ($applicant->research->predefenseApplied->defenseExaminer as $index => $examiner)
                                                            @if($applicant->research->supervisor->contains('supervisor_id', Auth::user()->staff->id))
                                                                @if(is_null($examiner->defenseExaminerPresence))
                                                                    <i wire:click="examinerPresence({{$examiner->id}}, {{$applicant->id}})" style="color:gray; cursor: pointer;" class="fa fa-check-circle"></i>
                                                                @else
                                                                    <i wire:click="examinerPresence({{$examiner->id}}, {{$applicant->id}})" style="color:green; cursor: pointer;" class="fa fa-check-circle"></i>
                                                                @endif
                                                            @endif
                                                            {{$examiner->staff->code}}
                                                            @if($examiner->additional == 1)
                                                                @if($applicant->research->supervisor->contains('supervisor_id', Auth::user()->staff->id))
                                                                    <i wire:click="unAssign({{$examiner->id}})" style="color:red; cursor: pointer;" class="fa fa-xs fa-user-minus"></i>
                                                                @endif
                                                            @endif
                                                            <br>
                                                        @endforeach
                                                    @endif
                                                </td>
                                                <td>
                                                    @if($applicant->confirmed == 1)
                                                        @if($applicant->session)
                                                            {{$applicant->session->time}}
                                                        @endif
                                                    @endif
                                                    <hr>
                                                    @if($applicant->confirmed == 1)
                                                        @if($applicant->space)
                                                            {{$applicant->space->description}}
                                                        @endif
                                                    @endif
                                                </td>
                                                <td class="text-right">
                                                    @if(!is_null($applicant->research->predefenseApplied->defenseExaminer))
                                                        @foreach ($applicant->research->predefenseApplied->defenseExaminer as $index => $examiner)
                                                            @if($examiner->defenseExaminerPresence)
                                                                @if($examiner->defenseExaminerPresence->examiner_id == Auth::user()->staff->id)
                                                                    @if(is_null($examiner->defenseExaminerPresence->score))
                                                                        <span wire:click="$emit('score_ArSysStaffExaminer', {{$examiner->id}})" style="cursor: pointer;color:gray"><i class="fa fa-sm fa-check-circle"></i> NULL</span>
                                                                    @else
                                                                        <span wire:click="$emit('score_ArSysStaffExaminer', {{$examiner->id}})" style="cursor: pointer;color:green"><i class="fa fa-sm fa-check-circle"></i> {{$examiner->defenseExaminerPresence->score}}</span>
                                                                    @endif
                                                                @endif
                                                            @endif
                                                        @endforeach
                                                    @endif

                                                    @if(!is_null($applicant->research->predefenseApplied->supervisor))
                                                        @foreach ($applicant->research->predefenseApplied->supervisor as $index => $supervisor)
                                                            @if($supervisor->supervisor_id == Auth::user()->staff->id)
                                                                @if($supervisor->defenseSupervisorPresence)
                                                                    @if(is_null($supervisor->defenseSupervisorPresence->score))
                                                                        <span wire:click="$emit('score_ArSysStaffSupervisor', {{$supervisor->id}}, {{$supervisor->defenseSupervisorPresence->event_id}})" style="cursor: pointer; color:gray"><i class="fa fa-sm fa-check-circle"></i> NULL</span>
                                                                    @else
                                                                        <span wire:click="$emit('score_ArSysStaffSupervisor', {{$supervisor->id}}, {{$supervisor->defenseSupervisorPresence->event_id}})" style="cursor: pointer; color:green"><i class="fa fa-sm fa-check-circle"></i>
                                                                        {{$supervisor->defenseSupervisorPresence->score}}</span>
                                                                    @endif
                                                                @endif
                                                            @endif
                                                        @endforeach
                                                    @endif
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2"></td>
                                                <td colspan="5">
                                                    <b>{{$applicant->research->code}}</b>
                                                    <br>
                                                    {!!$applicant->research->title!!}
                                                    @if(!is_null($applicant->research->predefenseApplied))
                                                        <hr>
                                                        @if($applicant->research->supervisor->contains('supervisor_id', Auth::user()->staff->id))
                                                            <i style="color:red">
                                                                Please click
                                                                <i style="color:gray;" class="fa fa-check-circle"></i>
                                                                for enabling score submission.
                                                            </i>
                                                            <livewire:staff.event.components.examiner :applicantId="$applicant->id" :wire:key="'examiner-'.$applicant->id">
                                                        @endif
                                                    @endif
                                                </td>
                                                <td></td>
                                            </tr>
                                        @endif
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @else
                        No applicant data
                    @endif
                </div>
            </div>
        </div>
    </div>
    <livewire:staff.event.components.score>
    <livewire:staff.event.components.score-supervisor>
</div>
