<div>
    <div class="row">
        <div class="col-md-3 offset-md-0">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            @if($students)
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="30%">Student</th>
                                <th width="20%">Supervisor</th>
                                <th width="24%">Specialization</th>
                                <th width="10%">Role</th>
                                <th width="10%" class="text-right">Action</th>
                                <th width="1%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($students as $index => $student)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr >
                                @endif

                                    <td >{{$index+1}}.</td>
                                    <td>
                                        {{$student->first_name}} {{$student->last_name}}
                                        <br>
                                        @if($student->program)
                                            {{$student->program->code}}
                                        @endif
                                        .{{$student->number}}
                                    </td>
                                    <td>
                                        @if($student->supervisor)
                                            {{$student->supervisor->first_name}} {{$student->supervisor->last_name}}
                                        @endif
                                    </td>
                                    <td>
                                        @if($student->specialization)
                                            {{$student->specialization->description}}
                                        @endif

                                    </td>
                                    <td>
                                        @if($student->user)
                                           @foreach($student->user->roles as $role)
                                                {{$role->display_name}}
                                           @endforeach
                                        @endif

                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$student->id}})"
                                                theme="success" icon="fa fa-xs fa-edit" class="btn btn-xs" label="View"/>
                                        @endif
                                        <x-adminlte-button   wire:click="loginAs({{$student->id}})"
                                            theme="warning" icon="fa fa-xs fa-sign-in" class="btn btn-xs" label="loginAs"/>
                                        <x-adminlte-button   wire:click="assignUserAndRole({{$student->id}})"
                                            theme="info" icon="fa fa-xs fa-user-plus" class="btn btn-xs" label="Assign"/>
                                    </td>
                                </tr>
                                @if($expandViewIndex[$index])
                                <tr>
                                    <td colspan="5">
                                        <div x-data="{viewStudent : @entangle('viewStudent') }">
                                            <div x-show="viewStudent">
                                                <livewire:admin.student.view :studentId="$student->id" :wire:key="'livewire:admin.student.view'">
                                                {{--
                                                <livewire:admin.student.edit :studentId="$student->id" :wire:key="'livewire:admin.student.edit'">
                                                    --}}
                                            </div>
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                @endif
                           @endforeach
                        </tbody>
                    </table>
                    {{$students->links()}}
                </div>
            @else
                No data
            @endif
        </div>
    </div>
</div>
