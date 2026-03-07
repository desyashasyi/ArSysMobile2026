<div>
    @if($approvals->isNotEmpty())
        
        <div class="row">
            <div class="col-md-4">
                <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
            </div>
        </div>       
        <div class="row">
            <div class="col-md-12">
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th></th>
                                <th width="2%">No</th>
                                <th width="25%">Student</th>
                                <th width="50%">Title</th>
                                <th width="10%" class="text-center">SPV(s)</th>
                                <th width="15%" class="text-right">Action</th>
                                <th width="1%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($approvals as $index => $approval)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td width="1%" class="bg-{{$approval->research->type->base->color}}"></td>
                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$approval->research->student->first_name}} {{$approval->research->student->last_name}}
                                        <br>
                                        {{$approval->research->student->program->code}}.{{$approval->research->student->number}}
                                    </td>
                                    <td>
                                        {{$approval->research->code}}-{{$approval->research->id}}
                                        <br>
                                        {{$approval->research->title}}        
                                    </td>
                                    <td class="text-center">
                                        @foreach ($approval->research->supervisor as $supervisor)
                                            {{$supervisor->staff->code}}
                                            <br>
                                        @endforeach
                                        @if($approval->research->supervisorexternal)
                                            {{$approval->research->supervisorexternal->institution}}
                                        @endif
                                    </td>
                                   
                                    <td  class="text-right">
                                        @if($approval->decision == null)
                                            <span wire:click="approve({{$approval->id}})" style="color:gray; cursor: pointer;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    </td>
                                </tr>    
                        @endforeach
                        </tbody>
                    </table>
                </div>

                {{$approvals->render()}}
            </div>
        </div>
    @else
        No data
    @endif
</div>
