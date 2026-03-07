<div>
    <div wire:ignore.self class="modal fade" id="addExaminerModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-xl" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addExaminerModal">Examiner Assignment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($applicantId)
                        @if($research )
                            <div class="row">
                                <div class="col-md-12 offset-md-0">
                                    @if($research !=null)
                                        <b>{{$research->student->program->code}}.{{$research->student->number}}</b>
                                        |
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br>
                                        <i>{!!$research->title!!}</i>
                                        <br>
                                        <br>
                                        <b>Supervisor</b> 
                                        <br>
                                        @foreach($research->supervisor as $index => $supervisor)
                                            {{$index+1}}. {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                            <br>
                                        @endforeach
                                        <hr>
                                        @if(!is_null($research->predefenseApplied->defenseExaminer))
                                            <b>Examiner</b> 
                                                
                                            <br>
                                            @php($counter = 0)
                                            @foreach ($research->predefenseApplied->defenseExaminer as $examiner)
                                                {{++$counter}}.
                                                {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                @if($examiner->order == 1)
                                                    <sup><i class="fa fa-sm fa-star" style="color: green;"></i></sup>
                                                @endif
                                                <button wire:click="unAssign({{ $examiner->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                                                <br>
                                            @endforeach
                                        @endif
                                    @endif
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-5 offset-md-0">
                                    <input wire:model="search" type="text" class="my-3 form-control" placeholder="Search staff name">
                                </div>
                            </div>
                        @endif
                        <div class="row">
                            <div class="col-md-12 offset-md-0" style="width: 100%; height: 200x; overflow-y: scroll; overflow-x: hidden">
                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <thead class="thead">
                                        <tr>
                                            <th rowspan="2" width="2%">No</th>
                                            <th rowspan="2" width="3%">Code</th>
                                            <th rowspan="2" width="25%">Name</th>
                                            <th rowspan="2" width="5%">Base</th>
                                            <th class="text-center" colspan="3" width="20%">
                                            Aggregate
                                            </th>
                                            <th colspan="2" class="text-center" width="10%">
                                                <span style="color: red">Present</span>
                                            </th>
                                            @foreach($programs as $program)
                                                <th class="text-center" colspan="2" width="10%">
                                                    {{$program->abbrev}}
                                                </th>
                                            @endforeach
                    
                                            <th rowspan="2" class="text-right" width="5%">Action</th>
                                        </tr>
                                        <tr>

                                            <th class="text-center">
                                                All
                                            </th class="text-center">
                                        
                                            <th class="text-center">
                                                1st
                                            </th>
                                            <th class="text-center">
                                                2&3
                                            </th>
                                            <th class="text-center">
                                                <span style="color: red">All</span>
                                            </th>
                                            <th class="text-center">
                                                <span style="color: red">1st</span>
                                            </th>
                                           
                                            @foreach($programs as $program)
                                                <th class="text-center">
                                                    1st
                                                </th>
                                                <th class="text-center">
                                                    2&3
                                                </th>
                                            @endforeach
                                        </tr>
                                        
                                        </thead>
                                        <tbody id="users-table">
                                            @foreach ($staffs as $index => $staff)
                                            <tr>
                                                <td>
                                                    {{$index+1}}.
                                                </td>
                                                <td>
                                                    {{$staff->code}}
                                                </td>
                                                <td>
                                                    {{$staff->first_name}} {{$staff->last_name}}
                                                </td>
                                                <td>
                                                    @if($staff->program)
                                                        {{$staff->program->abbrev}}
                                                    @endif
                                                </td>
                                                
                                                <td class="text-center">
                                                    @if(\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->get()->count() != 0)
                                                        {{\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->get()->count()}}
                                                    @endif
                                                </td>
                                            
                                                <td >
                                                </td>
                                                <td >
                                                
                                                </td>
                                                <td class="text-center">
                                                    @if(\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->where('event_id', $research->predefenseApplied->event_id)->get()->count() != 0)
                                                        <span style="color: red">
                                                            {{\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->where('event_id', $research->predefenseApplied->event_id)->get()->count()}}
                                                        </span>
                                                    @endif
                                                </td>
                                                <td class="text-center">
                                                    @if(\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->where('event_id', $research->predefenseApplied->event_id)->where('order',1)->get()->count() != 0)
                                                        <span style="color: red">
                                                            {{\App\Models\ArSys\DefenseExaminer::where('examiner_id', $staff->id)->where('event_id', $research->predefenseApplied->event_id)->where('order',1)->get()->count()}}
                                                        </span>
                                                    @endif
                                                </td>
                                                @foreach($programs as $program)
                                                    <td class="text-center">
                                                        @php($count = null)
                                                        @foreach ($staff->firstDefenseExaminer as $examiner)
                                                            @if($examiner->defenseApplicant->research->student->program_id ==  $program->id)
                                                                @php($count++)
                                                            @endif
                                                        @endforeach
                                                        @if($count != 0)
                                                            @if($staff->program_id == $program->id)
                                                                <b>{{$count}}</b>
                                                            @else
                                                                {{$count}}
                                                            @endif
                                                        @endif
                                                    </td>
                                                    <td class="text-center">
                                                        @php($count = null)
                                                        @foreach ($staff->secondDefenseExaminer as $examiner)
                                                            @if($examiner->defenseApplicant->research->student->program_id ==  $program->id)
                                                                @php($count++)
                                                            @endif
                                                        @endforeach
                                                        @if($count != 0)
                                                            @if($staff->program_id == $program->id)
                                                                <b>{{$count}}</b>
                                                            @else
                                                                {{$count}}
                                                            @endif
                                                        @endif
                                                    </td>
                                                @endforeach
                    
                                                <td class="text-right">
                                                    <button wire:click="assign_Specialization({{ $staff->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-plus" style ="color:green" aria-hidden="true"></i></button>
                                                </td>
                                            </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        {{$staffs->links()}}
                    @endif
                </div>
           </div>
        </div>
        <script>
            window.livewire.on('addExaminer_ArSysEventExaminer', () => {
                $('#addExaminerModal').modal('show');
            });
        </script>
    </div>
</div>

