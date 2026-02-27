<div>
    <div class="row">
        <div class="col-md-4">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
    </div>
    @if(!is_null($applicant))
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <div class="card card-outline card-success">
                    <div class="card-body">
                        <div class="table-responsive users-table">
                            <table class="table table-sm data-table">
                                <thead class="thead">
                                    <tr>
                                        <th class="bg-orange" width="1%"></th>
                                        <th width="33%">Student</th>
                                        <th width="10%" class="text-left">SPV(s)</th>
                                        <th width="15%" class="text-left">EX(s)</th>
                                        <th width="29%" class="text-left">
                                            Session and Space
                                        </th>
                                        <th class="text-right" width="10%">Score</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="bg-orange" width="1%"></td>

                                        <td>
                                            @if($applicant->research->student->program != null)
                                                {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                            @endif
                                            <br>
                                            {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                        </td>
                                        <td class="text-left">
                                            @if($applicant->research->supervisor != null)
                                                @forelse ($applicant->research->supervisor as $supervisor)

                                                    {{$supervisor->staff->code}}

                                                    <br>
                                                @empty
                                                @endforelse
                                            @endif
                                        </td>
                                        <td class="text-left">
                                            @if(!is_null($applicant->examiner))
                                                @foreach ($applicant->examiner as $index => $examiner)
                                                    @if(is_null($examiner->defenseExaminerPresence))
                                                        <i style="color:gray;" class="fa fa-check-circle"></i>
                                                    @else
                                                        <i style="color:green;" class="fa fa-check-circle"></i>
                                                    @endif
                                                    {{$examiner->staff->code}}
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
                                            @if(!is_null($applicant->examiner))
                                                @foreach ($applicant->examiner as $index => $examiner)
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

                                            @if(!is_null($applicant->research->supervisor))
                                                @foreach ($applicant->research->supervisor as $index => $supervisor)
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
                                        <td colspan="4">
                                            <b>{{$applicant->research->code}}</b>
                                            <br>
                                            {!!$applicant->research->title!!}
                                        </td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    @endif
    <livewire:staff.event.components.score>
    <livewire:staff.event.components.score-supervisor>
</div>
