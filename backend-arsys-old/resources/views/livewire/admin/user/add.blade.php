<div>
    <div class="card" wire:key='"arsys-admin-user-components-account-add'>
        <div class="card-header bg-warning">
            <div class="row">
                <div class="col-md-12 text-right">
                    <i class="fa fa-times-circle" wire:click="$emitUp('addAccountEnable_AdminUserAccount')" style="color: red; cursor:pointer" ></i>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <x-adminlte-input name="username" wire:model="username" label="Username" style="width: 100%">
                    </x-adminlte-input>
                    @error('username') <i class="text-xs text-danger">{{ $message }}</i><br> @enderror
                </div>
                <div class="col-md-4">
                    <x-adminlte-input type="number" name="sso" wire:model="sso" label="SSO" style="width: 100%"/>
                    @error('sso') <i class="text-xs text-danger">{{ $message }}</i><br> @enderror
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    <x-adminlte-input type="email" name="email" wire:model="email" label="Email" style="width: 100%"/>
                    @error('email') <i class="text-xs text-danger">{{ $message }}</i><br> @enderror
                </div>
                <div  class="col-md-6" wire:ignore >
                    @php
                        $config = [
                            "placeholder" => "Please select user role...",
                            "allowClear" => true,
                        ];
                    @endphp
                    <x-adminlte-select2  id="role" name="role" label="Role"
                        label-class="text-dark" igroup-size="md" :config="$config" multiple>
                        @foreach ($roles as $index => $role)
                            <option value="{{$role->id}}">{{$role->display_name}}</option>
                        @endforeach
                    </x-adminlte-select2>
                    @error('roles') <i class="text-xs text-danger">{{ $message }}</i> <br>@enderror
                </div>
            </div>
            <hr>

            <div class="row">
                <div class="col-md-12 text-left">
                    <x-adminlte-button   wire:click="save" theme="success" icon="fa fa-save" class="btn btn-sm" label="Save"/>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#role').on('change', function (e) {
                    let userRolesData = $(this).val();
                    @this.set('userRoles', userRolesData);
                    //@this.set('userRoles', $(this).val());
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectUserRole',()=>{
                    $('#role').select2('destroy');
                    $('#role').select2();
                });
            });
        </script>
    @endpush     
</div>