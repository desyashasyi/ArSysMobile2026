<div>
    @if(is_null($addUnregisteredStudent))
        <br>
        <div class="row">
            <div class="text-right col-md-12">
                <x-adminlte-button wire:click="addStudents" theme="success"
                    icon="fa fa-plus-circle" class="btn btn-xs btn-sm" label="Add Final Defense Participants" />
            </div>
        </div>
    @endif
    @if(!is_null($addUnregisteredStudent))
        <br>
        <div class="row">
            <div class="text-right col-md-12">
                <span style="color:red; cursor: pointer;"><i wire:click="addStudents"  class="fa fa-xs fa-times-circle"></i> close</span>
            </div>
        </div>
        @if($extraResearchs->isNotEmpty())
            <div class="row">
                <div class="text-left col-md-12">
                    <span style="color:blue"><i class="fa fa-sm fa-user-circle"></i> <b>Student who will be added in the yudicium proposal</b></span>
                </div>
            </div>
            <div class="row">
                <div class="text-left col-md-12">
                    <div class="table-responsive users-table">
                        <table class="table table-sm data-table">
                            <thead class="thead">
                                <tr>
                                    <th width="60%">Students</th>
                                    <th class="text-left" width="25%">Supervisor</th>
                                    <th class="text-right" width="14%">Action</th>
                                    <th width="1%"></th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($extraResearchs as $applicant)
                                <tr>
                                    <td>
                                        {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                        <br>
                                        {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                    </td>
                                    <td class="text-left">
                                        @if($applicant->research->supervisor != null)
                                            @forelse ($applicant->research->supervisor as $supervisor)

                                                {{$supervisor->staff->first_name}}  {{$supervisor->staff->last_name}} 
                                               
                                                <br>
                                            @empty
                                            @endforelse
                                        @endif
                                    </td>
                                    <td class="text-right">
                                        <span style="cursor: pointer; color:red" wire:click="addResearch({{$applicant->research->id}})">
                                            <i  class="fa fa-xs fa-minus-circle" ></i>
                                            <u>remove</u>
                                        </span>
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            {{$extraResearchs->render()}}
        @endif
        <hr>
        @if($unregisteredResearchs->isNotEmpty())
            <div class="row">
                <div class="text-left col-md-12">
                    <span style="color:blue"><i class="fa fa-sm fa-user-circle"></i> <b>Student who need to be included in the yudicium proposal</b></span>
                </div>
            </div>
            <div class="row">
                <div class="text-left col-md-12">
                    <div class="table-responsive users-table">
                        <table class="table table-sm data-table">
                            <thead class="thead">
                                <tr>
                                    <th width="35%">Students</th>
                                    <th width="25%">Milestone</th>
                                    <th width="30%">Approval</th>
                                    <th class="text-right" width="14%">Action</th>
                                    <th width="1%"></th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($unregisteredResearchs as $research)
                                    <tr>
                                        <td>
                                            {{$research->student->program->code}}.{{$research->student->number}}
                                            <br>
                                            {{$research->student->first_name}} {{$research->student->last_name}}
                                        </td>
                                        <td>
                                            <b>{{$research->milestone->code}}</b>
                                            <br>
                                            {{$research->milestone->phase}}
                                        </td>
                                        <td>
                                            @if($research->finaldefenseApproval->isNotEmpty())
                                                @php($count = 0)
                                                @foreach($research->finaldefenseApproval as $index => $approval)
                                                    @if($approval->decision == null)
                                                        <span style="color:gray;"><i class="fas fa-md fa-check-circle"></i></span>
                                                    @else
                                                        <span style="color:green;"><i class="fas fa-md fa-check-circle"></i></span>
                                                    @endif
                                                    {{$approval->staff->code}} 
                                                    @if( $count < $research->finaldefenseApproval->count()-1)
                                                        &nbsp;|&nbsp;
                                                    @endif
                                                    @php($count++)
                                                @endforeach
                                            @endif
                                        </td>
                                        <td class="text-right">
                                            <span style="cursor: pointer; color:green" wire:click="addResearch({{$research->id}})">
                                                <i  class="fa fa-xs fa-plus-circle" ></i>
                                                <u>Add</u>
                                            </span>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            {{$unregisteredResearchs->render()}}
        @endif
        
    @else
        @if($unregisteredResearchs->count() != 0)
            <span style="color:red">
                All students who are in the in-progress phase of the Final-defense can be included in yudidium proposal. 
                There is {{$unregisteredResearchs->count()}} students that have not apply this event.
                For this purpose, please <u wire:click="addStudents" style="color: blue; cursor: pointer;">register</u> the students.
            </span>
        @endif
    @endif
</div>
