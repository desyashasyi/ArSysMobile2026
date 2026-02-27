<div>
    <div wire:key="arsys.admin.staff.components.edit">
        <div wire:ignore.self class="modal fade" id="editStaffModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-lg" role="document">
               <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editStaffModal">Edit Staff</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body" style="width: 100%; height: 520px; overflow-y: scroll; overflow-x: hidden">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-6" >
                                        <x-adminlte-input placeholder="Not defined" wire:model="faculty" name="facultyEdit" label="Faculty" style="width: 100%" disabled/>
                                    </div>
                                    <div class="col-md-6">
                                        <x-adminlte-input placeholder="Not defined" wire:model="department" name="departmentEdit" label="Department" style="width: 100%" disabled/>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <x-adminlte-select2 label="Program of study" style="width: 100%" wire:model="program" id="programEdit" name="programEdit">
                                            <option default>Please select the program</option>
                                            @foreach ($programs as $index => $program)
                                                <option value="{{$program->id}}"><b>{{$program->code}}</b>-{{$program->name}}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                        @error('program') <span class="text-danger">{{ $message }}</span><br> @enderror
                    
                                    </div>  
                                    <div class="col-md-5">
                                        <x-adminlte-select2 label="Specialization" style="width: 100%" wire:model="specialization" id="specializationEdit" name="specializationEdit">
                                            <option default>Please select the specialization</option>
                                            @if(!is_null($specializations))
                                                @foreach ($specializations as $index => $specialization)
                                                @endforeach
                                            @endif
                                        </x-adminlte-select2>
                                        @error('specialization') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>  
                                </div>
        
                                <div class="row">
                                    <div class="col-md-6" >
                                        <x-adminlte-input placeholder="First name" wire:model="firstName" name="firstNameEdit" label="First name" style="width: 100%"/>
                                        @error('firstName') <span class="text-danger">{{ $message }}</span><br> @enderror
        
                                    </div>
                                    <div class="col-md-6">
                                        <x-adminlte-input placeholder="Last name" wire:model="lastName" name="lastNameEdit" label="Last name" style="width: 100%"/>
                                        @error('lastName') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <x-adminlte-input placeholder="Front title" wire:model="frontTitle" name="frontTitleEdit" id="frontTitleEdit" label="Front title" style="width: 100%"/>
                                        @error('frontTitle') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>
                                   
                                    <div class="col-md-4">
                                        <x-adminlte-input placeholder="Rear title" wire:model="rearTitle" name="rearTitleEdit" id="rearTitleEdit" label="Rear title" style="width: 100%"/>
                                        @error('rearTitle') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>
                                </div>
        
                                <div class="row">
                                    <div class="col-md-5">
                                        <x-adminlte-select2 label="Position" style="width: 100%" wire:model="position" id="positionEdit" name="positionEdit">
                                            <option default>Please select the position</option>
                                            @foreach ($positions as $index => $position)
                                                <option value="{{$position->id}}"><b>{{$position->code}}</b>-{{$position->description}}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                        @error('position') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>  
                                    <div class="col-md-5">
                                        <x-adminlte-select2 label="Structure" style="width: 100%" wire:model="structure" id="structureEdit" name="structureEdit">
                                            <option default>Please select the structure</option>
                                            @foreach ($structures as $index => $structure)
                                                <option value="{{$structure->id}}">{{$structure->structure}} - {{$structure->classification}}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                        @error('structure') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>  
                                </div>
        
                                <div class="row">
                                    <div class="col-md-4" >
                                        <x-adminlte-input placeholder="Employee Id" wire:model="employeeId" name="employeeId" label="Employee Id" style="width: 100%"/>
                                        @error('employeeId') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>
                                    <div class="col-md-4">
                                        <x-adminlte-input placeholder="Code" wire:model="code" name="code" label="Code" style="width: 100%"/>
                                        @error('code') <span class="text-danger">{{ $message }}</span><br> @enderror
                                    </div>
                                    <div class="col-md-4">
                                        <x-adminlte-input placeholder="Univ code" wire:model="univCode" name="univCode" label="University code" style="width: 100%"/>
                                        @error('univCode') <span class="text-danger">{{ $message }}</span><br> @enderror
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
                                <div class="row justify-content-left">
                                    <div class="col-md-12 text-left">
                                        <x-adminlte-button wire:click="update" theme="success" label="Update" class="btn-sm" icon="fas fa-save"/>
                                    </div>
                                </div>   
                                
                            </div>
                        </div>
                        
                    </div>
                    <div class="modal-footer">
                    </div>
               </div>
            </div>
            <script>
                window.livewire.on('editStaffModal_ArSysAdminStaffEdit', () => {
                    $('#editStaffModal').modal('show');
                });
            </script>
        </div>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#programEdit').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('program', dataProgram);
                    console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                $('#specializationEdit').on('change', function (e) {
                    let dataSpecialization = $(this).val();
                    @this.set('specialization', dataSpecialization);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });

                $('#positionEdit').on('change', function (e) {
                    let dataPosition = $(this).val();
                    @this.set('position', dataPosition);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });

                $('#structureEdit').on('change', function (e) {
                    let dataStructure = $(this).val();
                    @this.set('structure', dataStructure);
                    //window.livewire.emit('selectSpecialization');
                    //console.log('here');
                });
                
        

                window.livewire.on('reloadSelectProgram_AdminStaffEdit',()=>{
                    $('#programEdit').select2('destroy');
                    $('#programEdit').select2();
                    console.log('reload supervise meeting');
                });

                window.livewire.on('reloadSelectSpecializationEdit',()=>{
                    $('#specializationEdit').select2('destroy');
                    $('#specializationEdit').select2();
                });
                window.livewire.on('reloadSelectPositionEdit',()=>{
                    $('#positionEdit').select2('destroy');
                    $('#positionEdit').select2();
                });
                window.livewire.on('reloadSelectStructureEdit',()=>{
                    $('#structureEdit').select2('destroy');
                    $('#structureEdit').select2();
                });
            });
        </script>
    @endpush    
</div>

