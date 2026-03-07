<div>
    @if($student)
    <div class="row">
        <div class="col-md-12">
            <div class="row">
                <div class="col-md-6">
                    @if($student->program)
                        <x-adminlte-input placeholder="{{$student->program->faculty->name}}" name="faculty" label="Faculty" style="width: 100%" disabled/>
                    @else
                        <x-adminlte-input placeholder="" name="faculty" label="Faculty" style="width: 100%" disabled/>
                    @endif
                </div>
                <div class="col-md-6">
                    @if($student->program)
                        <x-adminlte-input placeholder="{{$student->program->cluster->data->name}}" name="cluster" label="Cluster" style="width: 100%" disabled/>
                    @else
                        <x-adminlte-input placeholder="" name="cluster" label="Cluster" style="width: 100%" disabled/>
                    @endif
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                    @if($student->program)
                        <x-adminlte-input placeholder="{{$student->program->code}}-{{$student->program->name}}" name="program" label="Program of study" style="width: 100%" disabled/>
                    @else
                        <x-adminlte-input placeholder="" name="program" label="Program of study" style="width: 100%" disabled/>
                    @endif
                </div>  
                <div class="col-md-5">
                    @if($student->specialization)
                        <x-adminlte-input placeholder="{{$student->specialization->code}}-{{$student->specialization->description}}" name="specialization" label="Specialization" style="width: 100%" disabled/>
                    @else
                        <x-adminlte-input placeholder="Not defined" name="specialization" label="Specialization" style="width: 100%" disabled/>
                    @endif
                </div>  
            </div>
            <div class="row">
                <div class="col-md-6">
                    @if($student->supervisor)
                        <x-adminlte-input
                        placeholder="{{$student->supervisor->front_title}} {{$student->supervisor->first_name}} {{$student->supervisor->last_name}}, {{$student->supervisor->rear_title}}"
                        name="supervisor" label="Supervisor" style="width: 100%" disabled
                        />
                    @else
                        <x-adminlte-input
                        placeholder=""
                        name="supervisor" label="Supervisor" style="width: 100%" disabled
                        />
                    @endif
                </div>
            </div>  
        </div>
    </div>
    <div class="row">
        <div class="col-md-3">
            <x-adminlte-input placeholder="{{$student->number}}" name="studentNumber" label="Student number" style="width: 100%" disabled/>
        </div>
        <div class="col-md-3">
            <x-adminlte-input placeholder="{{$student->phone}}" name="phoneNumber" label="Phone number" style="width: 100%" disabled/>
        </div>
        <div class="col-md-4" >
            <x-adminlte-input placeholder="{{$student->email}}" name="email" label="Email" style="width: 100%" disabled/>
        </div>     
    </div>
    <div class="row">
        <div class="col-md-4">
            <x-adminlte-input placeholder="{{$student->first_name}}" name="firstName" label="First name" style="width: 100%" disabled/>
        </div>
        <div class="col-md-5" >
            <x-adminlte-input placeholder="{{$student->last_name}}" name="lastName" label="Last name" style="width: 100%" disabled/>
        </div>     
    </div>
    <x-adminlte-button theme="warning" class="btn btn-sm" icon="fa fa-edit" wire:click="edit" label="Edit"/>
    @endif
</div>