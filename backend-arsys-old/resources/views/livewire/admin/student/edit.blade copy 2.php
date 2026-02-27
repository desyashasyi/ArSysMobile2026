<div>
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
                            <div class="col-md-6">
                                <x-adminlte-input placeholder="studentProgramEdit" wire:model="studentProgramEdit" name="studentProgramEdit" label="Program" style="width: 100%"/>
                                @error('studentProgramEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>  
                            <div class="col-md-3" >
                                <x-adminlte-input placeholder="Student Id" wire:model="studentId" name="studentId" label="Student Id" style="width: 100%"/>
                                @error('studentId') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <x-adminlte-input placeholder="studentSpecializationEdit" wire:model="studentSpecializationEdit" name="studentSpecializationEdit" label="Specialization" style="width: 100%"/>
                                @error('studentSpecializationEdit') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>  
                            <div class="col-md-5">
                                <x-adminlte-input placeholder="studentSupervisorEdit" wire:model="studentSupervisorEdit" name="studentSupervisorEdit" label="Supervisor" style="width: 100%"/>
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
</div>
