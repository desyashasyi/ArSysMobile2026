<div>
    
    <div class="row">
        <div class="col-md-3 offset-md-0">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive users-table">
                <table class="table table-sm data-table">
                    <thead class="thead">
                        <tr>
                            <th width="5%">No</th>
                            <th width="15%">Number</th>
                            <th width="30%">Student Name</th>
                            <th width="25%">Supervisor</th>
                            <th width="10%">Role</th>
                            <th width="5% text-center">Telegram</th>
                            <th class="text-right" width="15%">Action</th>
                           
                        </tr>
                    </thead>
                    <tbody>
                      @foreach ($students as $index => $student )
                          <tr>
                            <td>
                                {{$index+1}}
                            </td>
                            <td>
                                @if(!is_null($student->program))
                                    {{$student->program->code}}.
                                @endif
                                {{$student->number}}
                            </td>
                            <td>
                                {{$student->first_name}} {{$student->last_name}}
                            </td>
                            <td>
                                @if(!is_null($student->supervisor))
                                    {{$student->supervisor->first_name}}  {{$student->supervisor->last_name}}
                                @endif
                            </td>
                            <td>
                                @if($student->user)
                                    @if($student->user->role)
                                        @foreach($student->user->role as $role)
                                            {{$role->name}}
                                            <br>
                                        @endforeach
                                    @endif
                                @endif
                            </td>
                            <td class="text-center">
                                @if(!is_null($student->user))
                                    @if(!is_null($student->user->telegram))
                                        <i class="fa fa-check-circle" style="color:green"></i>
                                    @endif
                                @endif
                            </td>
                            <td class="text-right">
                                <button wire:click="loginAs({{$student->id}})"  class="btn btn-xs btn-warning"><i class="fa fa-xs fa-user" aria-hidden="true"></i> Login</button>
                            </td>
                          </tr>
                      @endforeach
                    </tbody>
                </table>
                {{$students->render()}}
            </div>
        </div>
    </div>
</div>
