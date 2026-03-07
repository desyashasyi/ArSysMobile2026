<div>
    {{--@foreach ($applicants as $index => $applicant)
        {{$applicant->research->student->first_name}}&nbsp;
    @endforeach
    --}}
    <div class="row">
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                <div class="card-body">
                    @if($eventApplicants->isNotEmpty())
                        {{--
                        <livewire:specialization.event.defense.others-defense :eventId="$eventId">
                        <br>
                        --}}
                        <div class="table-responsive users-table">
                            <table class="table table-sm data-table">
                                <thead class="thead">
                                    <tr>
                                        <td class="bg-orange" width="1%"></td>
                                        <th width="4%">No</th>
                                        <th width="20%">Student</th>
                                        <th width="60%">Research</th>
                                        @if($eventApplicants->contains('program_id', Auth::user()->staff->program_id))
                                            <th class="text-right" width="15%">Action</th>
                                        @endif
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach ($eventApplicants as $index => $applicant)
                                        @if($index%2 == 0)
                                            <tr class="bg-light">
                                        @else
                                            <tr>
                                        @endif
                                        @if(is_null($applicant->publish))
                                            <td class="bg-gray">
                                            </td>
                                        @else
                                            <td class="bg-green">
                                            </td>
                                        @endif
                                        <td>
                                            {{$index+1}}
                                        </td>
                                        <td>
                                            @if($applicant->research->student->program != null)
                                                {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                            @endif
                                            <br>
                                            {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                        </td>
                                        <td>
                                            <b>{{$applicant->research->code}}</b>
                                            <br>
                                            {!!$applicant->research->title!!}
                                        </td>
                                        @if(Auth::user()->staff->program_id == $applicant->event->program->id)
                                            <td class="text-right">
                                                @if($applicant->confirmed == 1)
                                                    <span style="color:gray">
                                                        <i class="fas fa-xs fa-check-circle" ></i>
                                                        <u>confirmed</u>
                                                    </span>
                                                @else
                                                    <span wire:click="confirm({{$applicant->id}})" style="cursor: pointer;color:green">
                                                        <i style="color:green" class="fas fa-xs fa-check-circle" ></i>
                                                        <u>confirm</u>
                                                    </span>
                                                @endif
                                                <br>
                                                <span wire:click="$emit('change_ArSysSpecializationEvent', {{$applicant->id}}, {{$applicant->event->type->id}})" style="cursor: pointer;color:green">
                                                    <i style="color:green" class="fas fa-xs fa-edit" ></i>
                                                    <u>change</u>
                                                </span>
                                            </td>
                                        @endif
                                    </tr>
                                        @if($applicant->confirmed == 1)
                                            <tr>
                                                <td colspan="3"></td>
                                                <td colspan="3">
                                                    <div class="table-responsive users-table">
                                                        <table class="table table-sm data-table">
                                                            <thead class="thead">
                                                                <tr>
                                                                    <th class="text-left" width="20%">SPV(s)</th>
                                                                    <th class="text-left" width="25%">
                                                                        @if($applicant->confirmed == 1 && Auth::user()->staff->program_id == $applicant->event->program->id)
                                                                            <span wire:click="$emit('examiner_ArSysEventExaminer', {{$applicant->id}})" style="cursor: pointer;color:green">
                                                                                <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                                                                <u>EX(s)</u>
                                                                            </span>
                                                                        @else
                                                                            <u>EX(s)</u>
                                                                        @endif
                                                                    </th>
                                                                    <th class="text-left" width="30%">
                                                                        @if($applicant->confirmed == 1 && Auth::user()->staff->program_id == $applicant->event->program->id)
                                                                            <span  style="cursor: pointer; color:green" wire:click="$emit('space_ArSysSpecializationEventApplicant', {{$applicant->id}},'Defense')">
                                                                                <i  class="fa fa-xs fa-building" ></i>
                                                                                <u>Space</u>
                                                                            </span>
                                                                        @else
                                                                            <u>Space</u>
                                                                        @endif
                                                                    </th>
                                                                    <th class="text-right" width="25%">
                                                                        @if($applicant->confirmed == 1 && Auth::user()->staff->program_id == $applicant->event->program->id)
                                                                            <span style="cursor: pointer; color:green" wire:click="$emit('session_ArSysSpecializationEventApplicant', {{$applicant->id}},'Defense')">
                                                                                <i  class="fa fa-xs fa-clock" ></i>
                                                                                <u>Session</u>
                                                                            </span>
                                                                        @else
                                                                            <u>Session</u>
                                                                        @endif
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
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
                                                                        @if($applicant->confirmed == 1)
                                                                            @if(!is_null($applicant->research->predefenseApplied->defenseExaminer))
                                                                                @foreach ($applicant->research->predefenseApplied->defenseExaminer as $index => $examiner)
                                                                                    <div class="row">
                                                                                        <div class="col col-md-12 text-left">
                                                                                            @if(Auth::user()->staff->program_id == $applicant->event->program->id)
                                                                                                <span wire:click="setFirstExaminer({{$applicant->id}}, {{$examiner->examiner_id}})" style="cursor:pointer;">
                                                                                            @endif
                                                                                            @if($examiner->order == 1)
                                                                                                <sup>
                                                                                                    <i class="fa fa-sm fa-star" style="color: green;"></i>
                                                                                                </sup>
                                                                                            @else
                                                                                                <sup>
                                                                                                    <i class="fa fa-sm fa-star" style="color: gray;"></i>
                                                                                                </sup>
                                                                                            @endif
                                                                                            {{$examiner->staff->code}}
                                                                                            </span>
                                                                                        </div>
                                                                                    </div>
                                                                                @endforeach
                                                                            @endif
                                                                        @endif
                                                                    </td>
                                                                    <td class="text-left">
                                                                        @if($applicant->confirmed == 1)
                                                                            @if($applicant->space)
                                                                                {{$applicant->space->description}}
                                                                            @endif
                                                                        @endif
                                                                    </td>
                                                                    <td class="text-right">
                                                                        @if($applicant->confirmed == 1)
                                                                            @if($applicant->session)
                                                                                {{$applicant->session->time}}
                                                                            @endif
                                                                        @endif
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        @endif
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        {{$eventApplicants->render()}}
                    @else
                        No applicant data
                    @endif
                    <livewire:specialization.event.components.space>
                    <livewire:specialization.event.components.session>
                    <livewire:components.event.examiner>
                    <livewire:specialization.event.components.change>
                </div>
            </div>
        </div>
    </div>
</div>
