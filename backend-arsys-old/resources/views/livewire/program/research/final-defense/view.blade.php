<div>
    <div class="row">
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">

                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12 offset-sm-0">
                            <livewire:program.research.final-defense.letter :eventId="$eventId" :wire:key="'view-'.$eventId">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-md-12 offset-sm-0">
                        @if($eventApplicants->isNotEmpty())
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <thead class="thead">
                                        <tr>
                                            <th rowspan="2" valign= "center" width="2%">No</th>
                                            <th rowspan="2" valign= "center" width="20%">Student</th>
                                            <th class="text-left" width="25%" colspan="5">
                                                Pre Defense
                                            </th>
                                            <th colspan="10" width="50%" class="text-left">
                                                Final Defense
                                            </th>
                                        </tr>
                                        <tr>
                                            <th colspan="2" width="10%" class="text-left">
                                                Supervisors
                                            </th>
                                            <th colspan="3" width="15%" class="text-left">
                                                Examiners
                                            </th>
                                            <th colspan="2" width="10%" class="text-left">
                                                Supervisors
                                            </th>
                                            <th colspan="2" width="40%" class="text-left">
                                                Examiners
                                            </th>
                                        </tr>

                                    </thead>
                                    <tbody>
                                        @foreach ($eventApplicants as $index => $applicant)
                                            <tr>
                                                <td>
                                                    {{$index+1}}
                                                </td>
                                                <td>
                                                    {{$applicant->research->student->program->code}}.
                                                    {{$applicant->research->student->number}}
                                                    <br>
                                                    {{$applicant->research->student->first_name}}
                                                    {{$applicant->research->student->last_name}}
                                                </td>
                                                @foreach($applicant->research->supervisor as $supervisor)
                                                    <td class="text-left" width="5%">
                                                        <b>{{$supervisor->staff->code}}</b>
                                                        <br>
                                                        @if(!is_null($supervisor->defenseSupervisorPresence))
                                                            @if(is_null($supervisor->defenseSupervisorPresence->score))
                                                                -
                                                            @else
                                                                {{$supervisor->defenseSupervisorPresence->score}}
                                                            @endif
                                                        @endif
                                                    </td>
                                                @endforeach
                                                @if($applicant->research->supervisor->count() == 1)
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                @endif

                                                @php($examinerPresence = 0)
                                                @foreach($applicant->research->predefensePublished->defenseExaminer as $examiner)
                                                    @if(!is_null($examiner->defenseExaminerPresence))
                                                        <td class="text-left" width="5%">
                                                            <b>{{$examiner->staff->code}}</b>
                                                            <br>
                                                            @if(is_null($examiner->defenseExaminerPresence->score))
                                                                -
                                                            @else
                                                                {{$examiner->defenseExaminerPresence->score}}
                                                            @endif
                                                        </td>
                                                        @php($examinerPresence++)
                                                    @endif
                                                @endforeach
                                                @if($examinerPresence == 2)
                                                    <td></td>
                                                @endif

                                                @foreach($applicant->research->supervisor as $supervisor)
                                                    <td class="text-left" width="5%">
                                                        <b>{{$supervisor->staff->code}}</b>
                                                        <br>
                                                        @if(!is_null($supervisor->finaldefenseSupervisorPresence))
                                                            @if(is_null($supervisor->finaldefenseSupervisorPresence->score))
                                                                -
                                                            @else
                                                                {{$supervisor->finaldefenseSupervisorPresence->score}}
                                                            @endif

                                                        @endif
                                                    </td>
                                                @endforeach
                                                @if($applicant->research->supervisor->count() < 2)
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                @endif


                                                @foreach($applicant->research->finaldefensePublished->room->examiner as $examiner)
                                                    <td class="text-left" width="5%">
                                                        <b>{{$examiner->staff->code}}</b>
                                                        <br>
                                                        @if(!is_null($examiner->presence))
                                                            @if(is_null($examiner->presence->score))
                                                                -
                                                            @else
                                                                @if($examiner->presence->score != -1)
                                                                    {{$examiner->presence->score}}
                                                                @else
                                                                    -
                                                                @endif
                                                            @endif

                                                        @endif
                                                    </td>
                                                @endforeach
                                                @if($applicant->research->finaldefensePublished->room->examiner->count() < 6)
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                @endif
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                            {{$eventApplicants->render()}}
                        @else
                            No applicant data
                        @endif
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
