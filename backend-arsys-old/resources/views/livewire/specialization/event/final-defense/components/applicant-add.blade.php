<div>
    <div class="row">
        <div class="text-left col-md-12">
            <span wire:click="enableAddApplicant" style="cursor: pointer;"><i class="fa fa-sm fa-user-circle"></i> 
                <b style="color:blue"><u>Student could be added in the schedule</u></b>
            </span>
        </div>
    </div>
    @if(!is_null($finalDefenseAdd))
        <div class="row">
            <div class="text-left col-md-12">
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th class="text-right" width="5%">No</th>
                                <th width="30%">Student</th>
                                <th width="45%">Research</th>
                                <th class="text-right" width="19%">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($unApplyApplicants as $index => $research)
                                <tr>
                                    <td class="text-right">
                                        {{$index+1}}.
                                    </td>
                                    <td>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                        <br>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                    </td>
                                    <td>
                                        <b>{{$research->code}}-{{$research->id}}</b>
                                        <br>
                                        {!!$research->title!!}
                                    </td>
                                    <td class="text-right">
                                        <span style="cursor: pointer; color:green" wire:click="addParticipant({{$research->id}})">
                                            <i  class="fa fa-sm fa-plus-circle" ></i>
                                            <u>add participant</u>
                                        </span>
                                        {{--
                                        <br>
                                        <span style="cursor: pointer; color:green" wire:click="addResearch({{$research->id}})">
                                            <i  class="fa fa-sm fa-toggle-on" ></i>
                                            <u>open application</u>
                                        </span>
                                        --}}
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    @endif
</div>
