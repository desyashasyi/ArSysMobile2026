<div>
    <div wire:key="arsys.admin.staff.view">
        @if($staff)
            <div class="card">
                <div class="card-header bg-warning">
                    
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12 text-right">
                            <x-adminlte-button   wire:click="$emit('editStaff_ArSysAdminStaffEdit',{{$staff->id}})" theme="info" icon="fa fa-edit" class="btn btn-xs" label="Edit"/>
                        </div>
                    </div>  
                    <hr>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="row">
                                <div class="col-md-6" >
                                    @if(!is_null($staff->program) && !is_null($staff->program->department) && !is_null($staff->program->department->faculty))
                                        <x-adminlte-input disabled placeholder="{{$staff->program->department->faculty->code}} - {{$staff->program->department->faculty->name}}" name="facultyView" label="Faculty" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="facultyView" label="Faculty" style="width: 100%"/>
                                    @endif
                                </div>
                                <div class="col-md-6" >
                                    @if(!is_null($staff->program) && !is_null($staff->program->department))
                                        <x-adminlte-input disabled placeholder="{{$staff->program->department->code}} - {{$staff->program->department->description}}" name="departmentView" label="Department" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="departmentView" label="Department" style="width: 100%"/>
                                    @endif
                                </div>
                            </div>
        
                            <div class="row">
                                <div class="col-md-5">
                                    @if(!is_null($staff->program))
                                        <x-adminlte-input disabled placeholder="{{$staff->program->code}} - {{$staff->program->name}}" name="programView" label="Program" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="programView" label="Program" style="width: 100%"/>
                                    @endif  
                                </div>
                                <div class="col-md-5">
                                    @if(!is_null($staff->program) && !is_null($staff->specialization))
                                        <x-adminlte-input disabled placeholder="{{$staff->specialization->code}} - {{$staff->specialization->description}}" name="specializationView" label="Specialization" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="specializationView" label="Specialization" style="width: 100%"/>
                                    @endif 
                                </div>  
                            </div>
        
                            <div class="row">
                                <div class="col-md-6" >
                                    <x-adminlte-input disabled placeholder="{{$staff->first_name}}" name="firstNamView" label="First name" style="width: 100%"/>
        
                                </div>
                                <div class="col-md-6">
                                    <x-adminlte-input disabled placeholder="{{$staff->last_name}}" name="lastNameView" label="Last name" style="width: 100%"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4" >
                                    <x-adminlte-input disabled placeholder="{{$staff->front_title}}" name="frontTitleView" label="Front title" style="width: 100%"/>
                                </div>
                                <div class="col-md-4">
                                    <x-adminlte-input disabled placeholder="{{$staff->rear_title}}" name="rearTitleView" label="Rear title" style="width: 100%"/>
                                </div>
                            </div>
        
                            <div class="row">
                                <div class="col-md-5">
                                    @if(!is_null($staff->position))
                                        <x-adminlte-input disabled placeholder="{{$staff->position->description}}" name="positionView" label="Position" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="positionView" label="Position" style="width: 100%"/>
                                    @endif
                                </div>  
                                <div class="col-md-5">
                                    @if(!is_null($staff->structure))
                                        <x-adminlte-input disabled placeholder="{{$staff->structure->structure}} {{$staff->structure->classification}}" name="structureView" label="Struture" style="width: 100%"/>
                                    @else
                                        <x-adminlte-input disabled name="structureView" label="Struture" style="width: 100%"/>
                                    @endif
                                </div>  
                            </div>
        
                            <div class="row">
                                <div class="col-md-4" >
                                    <x-adminlte-input disabled placeholder="{{$staff->employee_id}}" name="employeeIdView" label="Employee Id" style="width: 100%"/>
                                </div>
                                <div class="col-md-4">
                                    <x-adminlte-input disabled placeholder="{{$staff->code}}" name="codeView" label="Code" style="width: 100%"/>
                                </div>
                                <div class="col-md-4">
                                    <x-adminlte-input disabled placeholder="{{$staff->univ_code}}" name="univCodeView" label="University code" style="width: 100%"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4" >
                                    <x-adminlte-input disabled placeholder="{{$staff->phone}}" name="phoneView" label="Phone number" type="number" style="width: 100%"/>
                                </div>
                                <div class="col-md-4">
                                    <x-adminlte-input disabled placeholder="{{$staff->email}}" name="emailView" label="Email" type="email" style="width: 100%"/>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>  
            </div>
        @endif
    </div>
</div>
