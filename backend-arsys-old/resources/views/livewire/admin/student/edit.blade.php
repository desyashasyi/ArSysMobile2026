<div>
    {{$studentID}}
    <div x-data="{editStudentEnable: @entangle('editStudentEnable')}">
        <div x-show="editStudentEnable">
            @if(!is_null($student))
                <div class="card">
                    <div class="card-header bg-warning">
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
                            <div class="col-md-6" wire:ignore>
                                <x-adminlte-select2 label="Program of study" style="width: 100%" wire:model="studentProgramEdit" id="{{$studentID}}" name="{{$studentID}}">
                                    <option default>Please select the program</option>
                                    @foreach ($programs as $index => $program)
                                        <option value="{{$program->id}}"><b>{{$program->code}}</b>-{{$program->name}}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('studentProgramEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                            <div class="col-md-3" >
                                <x-adminlte-input placeholder="Student Id" wire:model="studentId" name="studentId" label="Student Id" style="width: 100%"/>
                                @error('studentId') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <x-adminlte-select2 label="Specialization" style="width: 100%" wire:model="studentSpecializationEdit" id="studentSpecializationEdit" name="studentSpecializationEdit">
                                    <option default>Please select the specialization</option>
                                    @foreach ($specializations as $index => $specialization)
                                        <option value="{{$specialization->id}}"><b>{{$specialization->data->code}}</b>-{{$specialization->data->description}}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('studentSpecializationEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>  
                            <div class="col-md-5">
                                <x-adminlte-select2 label="Supervisor" style="width: 100%" wire:model="studentSupervisorEdit" id="studentSupervisorEdit" name="studentSupervisorEdit">
                                    <option default>Please select the supervisor</option>
                                    @foreach ($supervisors as $index => $supervisor)
                                        <option value="{{$supervisor->id}}">{{$supervisor->code}} | {{$supervisor->first_name}} {{$supervisor->last_name}}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('studentSupervisorEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
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
                            <div class="col-md-12">
                                <x-adminlte-button   wire:click="closeView({{$student->id}})" theme="success" icon="fa fa-save" class="btn btn-xs" label="Update"/>
                                <x-adminlte-button wire:click="closeEdit({{$student->id}})" theme="danger" label="Cancel" icon="fa fa-times-circle" class="btn btn-xs"/>
                            </div>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#{{$studentID}}').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('{{$studentID}}', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectstudentProgramEdit',()=>{
                    $('#{{$studentId}}').select2('destroy');
                    $('#{{$studentId}}').select2();
                });

                $('#studentSpecializationEdit').on('change', function (e) {
                    let dataSpecialization = $(this).val();
                    @this.set('studentSpecializationEdit', dataSpecialization);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });

                window.livewire.on('reloadSelectstudentSpecializationEdit',()=>{
                    $('#studentSpecializationEdit').select2('destroy');
                    $('#studentSpecializationEdit').select2();
                });

                $('#studentSupervisorEdit').on('change', function (e) {
                    let dataSupervisor = $(this).val();
                    @this.set('studentSupervisorEdit', dataSupervisor);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });
                window.livewire.on('reloadSelectstudentSupervisorEdit',()=>{
                $('#studentSupervisorEdit').select2('destroy');
                $('#studentSupervisorEdit').select2();
            });
            });
        </script>
    @endpush    
</div>
