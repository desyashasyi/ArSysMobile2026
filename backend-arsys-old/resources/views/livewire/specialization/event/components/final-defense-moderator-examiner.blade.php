<div>
    <div wire:ignore.self class="modal fade" id="addModeratorAndExaminerModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addModeratorAndExaminerModal">{{$finalDefenseRole}} Assignment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($roomId)
                        <div class="row">
                            <div class="col-md-12 offset-md-0">
                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <tbody id="users-table">
                                            <tr>
                                                <td width="50%">
                                                    <b>Moderator</b>
                                                    <br>
                                                    @if(!is_null($room->moderator))
                                                        {{$room->moderator->first_name}} {{$room->moderator->last_name}}
                                                        @if($finalDefenseRole == 'Moderator')
                                                            <button wire:click="unAssign({{$room->moderator->id}})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                                                        @endif
                                                    @endif
                                                    <hr>
                                                    <b>Examiner</b>
                                                    <br>
                                                    @foreach($room->examiner as $index => $examiner)
                                                        {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                        @if($finalDefenseRole == 'Examiner' && $examiner->staff->id != $room->moderator->id)
                                                            <button wire:click="unAssign({{ $examiner->staff->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                                                        @endif
                                                        <br>
                                                    @endforeach
                                                </td>
                                                <td width="50%">
                                                    <b>Applicants</b>
                                                    <br>
                                                    @foreach($room->applicant as $index => $applicant)
                                                        @if($applicant->research->student->program_id != Auth::user()->staff->program->id)
                                                            <span style="color:gray">
                                                                {{$index+1}}.
                                                                {{$applicant->research->student->first_name}}
                                                                {{$applicant->research->student->last_name}}
                                                                ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                            </span>
                                                        @else
                                                            {{$index+1}}.
                                                            {{$applicant->research->student->first_name}}
                                                            {{$applicant->research->student->last_name}}
                                                            ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                        @endif
                                                        <br>
                                                    @endforeach        

                                                </td>
                                                
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5 offset-md-0">
                                <input wire:model="search" type="text" class="my-3 form-control" placeholder="Search staff name">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 offset-md-0" style="width: 100%; height: 200x; overflow-y: scroll; overflow-x: hidden">
                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <thead class="thead">
                                        <tr>
                                            <th rowspan="1" width="5%">No</th>
                                            <th rowspan="1" width="5%">Code</th>
                                            <th rowspan="1" width="70%">Name</th>
                                            <th rowspan="1" width="10%">Base</th>
                                            <th rowspan="2" class="text-right" width="10%">Action</th>
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
                                            
                                                    <td class="text-right">
                                                        <button wire:click="assign_SpecializationModeratorExaminerFinalDefense({{ $staff->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-plus" style ="color:green" aria-hidden="true"></i></button>
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
            window.livewire.on('addModeratorAndExaminer_ArSysEventExaminer', () => {
                $('#addModeratorAndExaminerModal').modal('show');
            });
        </script>
    </div>
</div>

