<div>
    <div class="card" wire:key='"arsys-admin-user-components-student-add'>
        <div class="card-header bg-warning">
            <div class="row">
                <div class="col-md-12 text-right">
                    <i class="fa fa-times-circle" wire:click="$emitUp('addStudentEnable_AdminUserStudent')" style="color: red; cursor:pointer" ></i>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-6" >
                            <x-adminlte-input placeholder="Not defined" wire:model="faculty" name="faculty" label="Faculty" style="width: 100%" disabled/>
                        </div>
                        <div class="col-md-6">
                            <x-adminlte-input placeholder="Not defined" wire:model="department" name="department" label="Department" style="width: 100%" disabled/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <x-adminlte-select2 label="Program of study" style="width: 100%" wire:model="studentProgram" id="studentProgram" name="studentProgram">
                        <option default>Please select the program</option>
                        @foreach ($programs as $index => $program)
                            <option value="{{$program->id}}"><b>{{$program->code}}</b>-{{$program->name}}</option>
                        @endforeach
                    </x-adminlte-select2>
                    @error('studenProgram') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
                <div class="col-md-3" >
                    <x-adminlte-input placeholder="Student Id" wire:model="studentId" name="studentId" label="Student Id" style="width: 100%"/>
                    @error('studentId') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <x-adminlte-select2 label="Specialization" style="width: 100%" wire:model="studentSpecialization" id="studentSpecialization" name="studentSpecialization">
                        <option default>Please select the specialization</option>
                        @foreach ($specializations as $index => $specialization)
                            <option value="{{$specialization->id}}"><b>{{$specialization->data->code}}</b>-{{$specialization->data->description}}</option>
                        @endforeach
                    </x-adminlte-select2>
                    @error('studentSpecialization') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>  
                <div class="col-md-5">
                    <x-adminlte-select2 label="Supervisor" style="width: 100%" wire:model="studentSupervisor" id="studentSupervisor" name="studentSupervisor">
                        <option default>Please select the supervisor</option>
                        @foreach ($supervisors as $index => $supervisor)
                            <option value="{{$supervisor->id}}">{{$supervisor->code}} | {{$supervisor->first_name}} {{$supervisor->last_name}}</option>
                        @endforeach
                    </x-adminlte-select2>
                    @error('studentSupervisor') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>  
            </div>
            <div class="row">
                <div class="col-md-6" >
                    <x-adminlte-input placeholder="First name" wire:model="firstName" name="firstName" label="First name" style="width: 100%"/>
                    @error('firstName') <span class="text-danger">{{ $message }}</span><br> @enderror

                </div>
                <div class="col-md-6">
                    <x-adminlte-input placeholder="Last name" wire:model="lastName" name="lastName" label="Last name" style="width: 100%"/>
                    @error('lastName') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
            </div>
            <div class="row">
                <div class="col-md-4" >
                    <x-adminlte-input placeholder="Phone number" wire:model="phone" name="phone" label="Phone number" type="number" style="width: 100%"/>
                    @error('phone') <span class="text-danger">{{ $message }}</span><br> @enderror
                </div>
                <div class="col-md-4">
                    <x-adminlte-input placeholder="Email address" wire:model="email" name="email" label="Email" type="email" style="width: 100%"/>
                    @error('email') <span class="text-danger">{{ $message }}</span><br> @enderror
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
                $('#studentProgram').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('studentProgram', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectStudentProgram',()=>{
                    $('#studentProgram').select2('destroy');
                    $('#studentProgram').select2();
                });

                $('#studentSpecialization').on('change', function (e) {
                    let dataSpecialization = $(this).val();
                    @this.set('studentSpecialization', dataSpecialization);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });

                window.livewire.on('reloadSelectStudentSpecialization',()=>{
                    $('#studentSpecialization').select2('destroy');
                    $('#studentSpecialization').select2();
                });

                $('#studentSupervisor').on('change', function (e) {
                    let dataSupervisor = $(this).val();
                    @this.set('studentSupervisor', dataSupervisor);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });
                window.livewire.on('reloadSelectStudentSupervisor',()=>{
                    $('#studentSupervisor').select2('destroy');
                    $('#studentSupervisor').select2();
                });
            });
        </script>
    @endpush       
</div>