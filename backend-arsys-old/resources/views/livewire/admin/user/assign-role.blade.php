<div>
    <!-- Modal -->
    <div wire:ignore.self class="modal fade" id="setUserRole" tabindex="-1" role="dialog" aria-labelledby="roleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="setUserRole">Assign role to user </h5>
                    <button type="button" wire:click="close" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            @if(!is_null($user))
                                {{$user->staff->code}} - {{$user->staff->employee_id}}
                                <br>
                                {{$user->staff->front_titel}} 
                                {{$user->staff->first_name}}
                                {{$user->staff->last_name}},
                                {{$user->staff->rear_title}}
                                <hr>
                                @if($user->roles->isNotEmpty())
                                    <b>User roles</b>
                                    <br>
                                    @foreach($user->roles as $role)
                                        {{$role->display_name}}
                                        <i wire:click="removeRole({{$role->id}})" style="color:red; cursor: pointer;" class="fa fa-xs fa-user-minus"></i>
                                        <br>
                                    @endforeach
                                @endif
                            @endif
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive users-table">
                                <table class="table table-striped table-sm data-table">
                                    <thead class="thead">
                                    <tr>
                                        <th class="text-left" width="5%">No</th>
                                        <th class="text-left" width="65%">Display Name</th>
                                        <th class="text-right" width="30%">Action</th>
                                    </tr>
                                    </thead>
                                    <tbody id="users-table">
                                        @if(!is_null($roles))
                                            @foreach($roles as $index => $role)
                                                <tr>
                                                    <td>
                                                        {{$index+1}}
                                                    </td>
                                                    <td>
                                                        {{$role->display_name}}
                                                    </td>
                                                    <td class="text-right">
                                                        <i wire:click="assignRole({{$role->id}})" style="color:green; cursor: pointer;" class="fa fa-xs fa-user-plus"></i>
                                                    </td>
                                                </tr>
                                            @endforeach
                                        @endif
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
        </div>
        </div>
    </div>
    @push('scripts')
        <script>
            window.livewire.on('setUserRoleModal_ArSysAdminUserPage', () => {
                $('#setUserRole').modal('show');
            });
        </script>
    @endpush
</div>
