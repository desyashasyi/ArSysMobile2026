<div>
    <div class="row">
        <div class="col-md-12 offset-md-0 text-right">
            <div x-data="{addAccountEnable : @entangle('addAccountEnable') }">
                @if(!$addAccountEnable)
                    <div class="row">
                        <div class="col-md-3 offset-md-0">
                            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search username">
                        </div>
                        <div class="col-md-9 text-right">
                        <x-adminlte-button   wire:click="addAccountEnable_AdminUserAccount" theme="success" icon="fa fa-plus-circle" class="btn btn-sm" label="Add user"/>
                        </div>
                    </div>
                @endif
                <div x-show="addAccountEnable">
                    <livewire:admin.user.add :wire:key="'arsys-admin-user-components-account-add'"/>
                </div>
            </div>
        </div>
    </div>
    <br>
    <div class="row">
        <div class="col-md-12">
            <div class="table-responsive users-table">
                <table class="table table-sm data-table">
                    <thead class="thead">
                        <tr>
                            <th width="5%">No</th>
                            <th width="15%">User Nama</th>
                            <th width="20%">SSO</th>
                            <th width="30%">Name</th>
                            <th width="20%">Role</th>
                            <th width="10%">Action</th>

                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($users as $index => $user)
                        <tr>
                            @if($index%2 ==0 )
                                <!--<tr class="bg-light" style="cursor: pointer" wire:click="expandView({{$index}}, {{$user->id}})">-->
                            @else
                                <!--<tr style="cursor: pointer" wire:click="expandView({{$index}}, {{$user->id}})">-->
                            @endif
                                    <td> {{$index+1}}</td>
                                @if(!$enabledExpandView[$index])
                                    <td>
                                        {{$user->name}}
                                    </td>
                                    <td>
                                        {{$user->sso}}
                                        <br>
                                        {{--
                                        @if(strlen($user->sso) == 7 && $user->student != null)
                                            Student
                                        @elseif(strlen($user->sso) >= 9 && $user->staff != null)
                                            Staff
                                        @else
                                            Program study role
                                        @endif
                                        --}}

                                    </td>
                                    <td>
                                        @if(strlen($user->sso) == 7 && $user->student != null)
                                            {{$user->student->first_name}} {{$user->student->last_name}}
                                        @elseif(strlen($user->sso) >= 9 && $user->staff != null)
                                            {{$user->staff->first_name}} {{$user->staff->last_name}}
                                        @else
                                            @if(!is_null($user->sysrole))
                                                {{$user->sysrole->code}}
                                            @endif
                                        @endif

                                    </td>

                                    <td>
                                        @foreach ($user->roles as $role)
                                            {{$role->display_name}}
                                            @if(strlen($user->sso) != 7)
                                                <button wire:click="removeRole({{$role->id}}, {{$user->id}})"  class="btn btn-xs"><i class="fa fa-xs fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                                            @endif
                                            <br>
                                        @endforeach
                                    </td>
                                    <td>
                                        <button wire:click="$emit('setUserRole_ArSysAdminUserPage', {{$user->id}})"  class="btn btn-xs btn-success"><i class="fa fa-xs fa-user-plus" aria-hidden="true"></i> Add role</button>
                                        <br>
                                        <button wire:click="loginAs({{$user->id}})"  class="btn btn-xs btn-warning"><i class="fa fa-xs fa-user" aria-hidden="true"></i> Login as</button>
                                    </td>

                                @else
                                    <td colspan="7" >
                                        <div class="text-center">
                                            <b>{{$user->name}}</b> Profile
                                            <br>
                                            <i style="color:red">Click to close</i>
                                        </div>
                                    </td>
                                @endif
                            </tr>
                            <tr>
                                @if($enabledExpandView[$index])
                                    <td colspan="8">
                                        <livewire:admin.user.view/>
                                        <livewire:arsys.admin.user.edit/>
                                    </td>
                                @endif
                            </tr>
                        @empty
                            No data
                        @endforelse

                    </tbody>
                </table>
                {{$users->render()}}
            </div>
        </div>
    </div>
    <livewire:admin.user.assign-role :wire:key="'arsys.admin.user.assign-role'"/>
</div>
