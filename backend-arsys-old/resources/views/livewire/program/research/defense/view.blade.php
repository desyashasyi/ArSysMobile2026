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
                                        <th width="2%">No</th>
                                        <th width="48%">Student</th>
                                        <th colspan="2" width="20%" class="text-left">Supervisors</th>
                                        <th colspan="3" width="30%" class="text-left">Examiners</th>
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
                                            <td class="text-left" width="10%">
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
                                        @if($applicant->research->supervisor->count() < 2)
                                            <td>
                                                &nbsp;
                                            </td>
                                        @endif
                                        @foreach($applicant->examiner as $examiner)
                                            @if(!is_null($examiner->defenseExaminerPresence))
                                                <td class="text-left" width="10%">
                                                    <b>{{$examiner->staff->code}}</b>
                                                    <br>
                                                    @if(is_null($examiner->defenseExaminerPresence->score))
                                                        -
                                                    @else
                                                        {{$examiner->defenseExaminerPresence->score}}
                                                    @endif
                                                </td>      
                                            @endif            
                                        @endforeach
                                        @if(!is_null($examiner->defenseExaminerPresence))
                                            @if($examiner->defenseExaminerPresence->count() < 3)
                                                <td>
                                                    &nbsp;
                                                </td>
                                            @endif
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
