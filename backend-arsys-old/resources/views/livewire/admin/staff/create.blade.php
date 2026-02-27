<div>
     
    <div wire:key='"arsys-admin-user-components-staff-create'>
        <div x-data="{addStaff : @entangle('addStaff') }">
            @if(!$addStaff)
                <div class="row">
                    <div class="col-md-12 text-right">
                        <x-adminlte-button name="btnAddStaff" wire:click="addStaff_AdminStaffPage" theme="success" icon="fa fa-plus-circle" class="btn btn-sm" label="Add staff"/>
                    </div>
                </div>
            @endif
            <div x-show="addStaff">
                <div class="row">
                    <div class="col-md-12 text-left">
                        <div class="card" >
                            <div class="card-header bg-warning">
                                <div class="row">
                                    <div class="col-md-4 text-left">
                                        <b>Add staff</b>
                                    </div>
                                    <div class="col-md-8 text-right">
                                        <i class="fa fa-times-circle" wire:click="addStaff_AdminStaffPage" style="color: red; cursor:pointer" ></i>
                                    </div>
                                </div>
                            </div>        
                                
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="row">
                                            <div class="col-md-6" >
                                                <x-adminlte-input placeholder="Not defined" wire:model="facultyCreate" name="facultyCreate" label="Faculty" style="width: 100%" disabled/>
                                            </div>
                                            <div class="col-md-6">
                                                <x-adminlte-input placeholder="Not defined" wire:model="departmentCreate" name="departmentCreate" label="Department" style="width: 100%" disabled/>
                                            </div>
                                        </div>
                    
                                        <div class="row">
                                            <div class="col-md-5">
                                                <x-adminlte-select2 label="Program of study" style="width: 100%" wire:model="programCreate" id="programCreate" name="programCreate">
                                                    <option default>Please select the program</option>
                                                    @foreach ($programs as $index => $program)
                                                        <option value="{{$program->id}}"><b>{{$program->code}}</b>-{{$program->name}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('programCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            
                                            </div>  
                                            <div class="col-md-5">
                                                <x-adminlte-select2 label="Specialization" style="width: 100%" wire:model="specializationCreate" id="specializationCreate" name="specializationCreate">
                                                    <option default>Please select the specialization</option>
                                                    @foreach ($specializations as $index => $specialization)
                                                        <option value="{{$specialization->id}}"><b>{{$specialization->code}}</b>-{{$specialization->description}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('specializationCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>  
                                        </div>
                    
                                        <div class="row">
                                            <div class="col-md-6" >
                                                <x-adminlte-input placeholder="First name" wire:model="firstNameCreate" name="firstNameCreate" label="First name" style="width: 100%"/>
                                                @error('firstNameCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-6">
                                                <x-adminlte-input placeholder="Last name" wire:model="lastNameCreate" name="lastNameCreate" label="Last name" style="width: 100%"/>
                                                @error('lastNameCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4" >
                                                <x-adminlte-input placeholder="Front title" wire:model="frontTitleCreate" name="frontTitleCreate" label="Front title" style="width: 100%"/>
                                                @error('frontTitleCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-4">
                                                <x-adminlte-input placeholder="Rear title" wire:model="rearTitleCreate" name="rearTitleCreate" label="Rear title" style="width: 100%"/>
                                                @error('rearTitleCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                    
                                        <div class="row">
                                            <div class="col-md-5">
                                                <x-adminlte-select2 label="Position" style="width: 100%" wire:model="positionCreate" id="positionCreate" name="positionCreate">
                                                    <option default>Please select the position</option>
                                                    @foreach ($positions as $index => $position)
                                                        <option value="{{$position->id}}"><b>{{$position->code}}</b>-{{$position->description}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('positionCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>  
                                            <div class="col-md-5">
                                                <x-adminlte-select2 label="Struture" style="width: 100%" wire:model="structureCreate" id="structureCreate" name="structureCreate">
                                                    <option default>Please select the structure</option>
                                                    @foreach ($structures as $index => $structure)
                                                        <option value="{{$structure->id}}">{{$structure->structure}} - {{$structure->classification}}</option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                                @error('structureCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>  
                                        </div>
                    
                                        <div class="row">
                                            <div class="col-md-4" >
                                                <x-adminlte-input placeholder="Employee Id" wire:model="employeeIdCreate" name="employeeIdCreate" label="Employee Id" style="width: 100%"/>
                                                @error('employeeIdCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-4">
                                                <x-adminlte-input placeholder="Code" wire:model="codeCreate" name="codeCreate" label="Code" style="width: 100%"/>
                                                @error('codeCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-4">
                                                <x-adminlte-input placeholder="Univ code" wire:model="univCodeCreate" name="univCodeCreate" label="University code" style="width: 100%"/>
                                                @error('univCodeCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4" >
                                                <x-adminlte-input placeholder="Phone number" wire:model="phoneCreate" name="phoneCreate" label="Phone number" type="number" style="width: 100%"/>
                                                @error('phoneCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                            <div class="col-md-4">
                                                <x-adminlte-input placeholder="Email address" wire:model="emailCreate" name="emailCreate" label="Email" type="email" style="width: 100%"/>
                                                @error('emailCreate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                            </div>
                                        </div>
                    
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
                    </div>
                </div>
            </div>
        </div>
        @push('scripts')
            <script>
                //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
                $(document).ready(function () {
                    $('#programCreate').on('change', function (e) {
                        let dataProgram = $(this).val();
                        @this.set('programCreate', dataProgram);
                        //console.log('here');
                        //window.livewire.emit('selectProgram');
                    });
                    $('#specializationCreate').on('change', function (e) {
                        let dataSpecialization = $(this).val();
                        @this.set('specializationCreate', dataSpecialization);
                        //console.log('here');
                        //window.livewire.emit('selectProgram');
                    });
                    
                    $('#positionCreate').on('change', function (e) {
                        let dataPosition = $(this).val();
                        @this.set('positionCreate', dataPosition);
                        //window.livewire.emit('selectSpecialization');
                        //console.log('here');
                    });

                    $('#structureCreate').on('change', function (e) {
                        let dataStructure = $(this).val();
                        @this.set('structureCreate', dataStructure);
                        //window.livewire.emit('selectSpecialization');
                        //console.log('here');
                    });


                    window.livewire.on('reloadSelectProgramCreate',()=>{
                        $('#programCreate').select2('destroy');
                        $('#programCreate').select2();
                    });

                    window.livewire.on('reloadSelectSpecializationCreate',()=>{
                        $('#specializationCreate').select2('destroy');
                        $('#specializationCreate').select2();
                    });
                    window.livewire.on('reloadSelectPositionCreate',()=>{
                        $('#positionCreate').select2('destroy');
                        $('#positionCreate').select2();
                    });
                    window.livewire.on('reloadSelectStructureCreate',()=>{
                        $('#structureCreate').select2('destroy');
                        $('#structureCreate').select2();
                    });
                });
            </script>
        @endpush       
    </div>              
</div>
