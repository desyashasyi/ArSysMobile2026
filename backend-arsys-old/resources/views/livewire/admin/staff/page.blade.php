<div>
    <div class="row">
        <div class="text-left col-md-12">
            <livewire:admin.staff.create :wire:key="'arsys.admin.staff.create'">
        </div>
    </div>
    <hr>
    {{--
    <div class="row">
        <div class="col-md-6 offset-md-0">
            <div class="text-left col-md-12">
                <div x-data="{includeClerk : @entangle('includeClerk') }">
                    <div x-show="includeClerk">
                        <button wire:click="includeClerk" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i> Include cluster</button>
                    </div>
                    <div x-show="!includeClerk">
                        <button wire:click="includeClerk" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i> Include cluster</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    --}}
    <div class="row">
        <div class="col-md-3 offset-md-0">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
    </div>
    <br>
    <div class="row">
        <div class="text-left col-md-12">
            @if($staffs)
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="5%">Code</th>
                                <th width="20%">Identity</th>
                                <th width="15%">Position</th>
                                <th width="25%">Role</th>
                                <th width="5%">Status</th>
                                <th class="text-right" width="15%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($staffs as $index => $staff)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td> {{$index+1}}</td>
                                    <td>
                                        {{$staff->code}}
                                    </td>

                                    <td>
                                        {{$staff->first_name}} {{$staff->last_name}}
                                        <br>
                                        {{$staff->employee_id}}
                                    </td>


                                    <td>
                                        @if(!is_null($staff->position))
                                            {{$staff->position->description}}
                                        @endif
                                    </td>

                                    <td>

                                        @if(!is_null($staff->user))
                                            {{--{$staff->user->id}} =
                                            {{$staff->user_id}}
                                            <br>
                                            --}}
                                            @foreach($staff->user->roles as $role)
                                                {{$role->display_name}}
                                                <br>
                                            @endforeach
                                        @endif
                                    </td>
                                    <td>
                                        @if(!is_null($staff->status))
                                            {{$staff->status->code}}
                                        @endif
                                    </td>
                                    <td class="text-right">
                                        @if(!$viewStaffIndex[$index])
                                            <i class="fa fa-xs fa-eye" style="cursor: pointer;color:green"
                                            wire:click="expandViewStaff({{$index}}, {{$staff->id}})"></i>
                                        @endif
                                        &nbsp;
                                        <i class="fa fa-xs fa-sign-in-alt " style="cursor: pointer;color:orange"
                                        wire:click="loginAs({{$staff->id}})"></i>
                                        &nbsp;
                                        <i class="fa fa-xs fa-user-plus" style="cursor: pointer;color:red"
                                        wire:click="assignRole({{$staff->id}})"></i>

                                    </td>
                                </tr>
                                @if($viewStaffIndex[$index])
                                    <tr>
                                        <td>
                                        </td>
                                        <td colspan="8" >
                                            <div class="text-left col-md-12">
                                                <div x-data="{viewStaff : @entangle('viewStaff') }">
                                                    <div x-show="viewStaff">
                                                        <livewire:admin.staff.view :wire:key="$staff->id" >
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="text-left col-md-12">
                                                <div x-data="{editStaff : @entangle('editStaff') }">
                                                    <div x-show="editStaff">
                                                    </div>
                                                </div>
                                            </div>

                                        </td>
                                    </tr>
                                @endif
                            @endforeach
                        </tbody>
                    </table>
                    {{$staffs->render()}}
                </div>
            @else
                No data
            @endif
        </div>
    </div>
    <livewire:admin.staff.components.edit :wire:key="'arsys.admin.staff.components.edit'">
</div>
