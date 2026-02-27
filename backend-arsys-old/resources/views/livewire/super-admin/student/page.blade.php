<div>
    <div class="row">
        <div class="col-md-3 offset-md-0">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            @if($studentUsers->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <td width="10%">User</td>
                                <th width="30%">Student</th>
                                <th width="20%">Supervisor</th>
                                <th width="24%">Specialization</th>
                                <th width="10%" class="text-right">Action</th>
                                <th width="1%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($studentUsers as $index => $user)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr >
                                @endif

                                    <td >{{$index+1}}.</td>
                                    <td>
                                        {{$user->sso}}
                                    </td>
                                    <td>
                                        @if($user->student)
                                            {{$user->student->first_name}} {{$user->student->last_name}}
                                            <br>
                                            @if($user->student->program)
                                                {{$user->student->program->code}}
                                            @endif
                                            .{{$user->student->number}}
                                        @endif
                                    </td>
                                    <td>
                                        @if($user->student)
                                            @if($user->student->supervisor)
                                                {{$user->student->supervisor->first_name}} {{$user->student->supervisor->last_name}}
                                            @endif
                                        @endif
                                    </td>
                                    <td>
                                        @if($user->student)
                                            @if($user->student->specialization)
                                                {{$user->student->specialization->description}}
                                            @endif
                                        @endif

                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$user->id}})"
                                                theme="success" icon="fa fa-xs fa-edit" class="btn btn-xs" label="View"/>
                                        @endif
                                        <x-adminlte-button   wire:click="loginAs({{$user->id}})"
                                            theme="warning" icon="fa fa-xs fa-sign-in" class="btn btn-xs" label="loginAs"/>
                                    </td>
                                </tr>
                                @if($expandViewIndex[$index])
                                <tr>
                                    <td colspan="5">
                                        <div x-data="{viewStudent : @entangle('viewStudent') }">
                                            <div x-show="viewStudent">
                                                <livewire:super-admin.student.components.view :userId="$user->id" :wire:key="'livewire:admin.student.view'">
                                                {{--
                                                <livewire:admin.student.edit :userId="$user->id" :wire:key="'livewire:admin.student.edit'">
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
                    {{$studentUsers->links()}}
                </div>
            @else
                No data
            @endif
        </div>
    </div>
</div>
