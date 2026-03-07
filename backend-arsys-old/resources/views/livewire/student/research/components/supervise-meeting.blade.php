<div>
    <div wire:key="arsys.student.research.components.supervise-meeting">
        <div wire:ignore.self class="modal fade" id="superviseMeetingModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-md" role="document">
               <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="superviseMeetingModal">Supervise Meeting</h5>
                        <button type="button" class="close" data-dismiss="modal" wire:click="close" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body" style="width: 100%; height: 520px; overflow-y: scroll; overflow-x: hidden">
                        <div class="row">
                            <div class="col-md-8">
                                <x-adminlte-select2 label="Supervisor" style="width: 100%" wire:model="supervisor" id="supervisorSuperviseMeeting" name="supervisorSuperviseMeeting">
                                    <option default>Please select the supervisor</option>
                                    @foreach ($supervisors as $index => $supervisor)
                                        <option value="{{$supervisor->id}}">{{$index+1}}. <b>{{$supervisor->staff->code}}</b>-
                                            {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('supervisor') <i class="text-danger">{{ $message }}</i><br> @enderror
                            </div>  
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                {{-- With prepend slot, sm size and label --}}
                                <x-adminlte-textarea wire:model="topic" name="topic" label="Topic" rows=2
                                igroup-size="sm" placeholder="Insert meeting topic...">
                                </x-adminlte-textarea>
                                @error('topic') <i class="text-danger">{{ $message }}</i><br> @enderror
                            </div>
                        </div>
                       
                        <div class="row">
                            <div class="col-md-6">
                                Date of Meeting
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div wire:ignore>
                                    <input wire:model="dateOfMeeting"
                                        class="w-full p-2 border border-gray-500 form-control focus:outline-none"
                                        name="my_date"
                                        id="dateOfMeeting"/>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" wire:ignore>
                                    <textarea type="text" wire:model="message" input="message" name="message" id="message" class="message"></textarea>
                                    @error('message') <i class="text-danger">{{ $message }}</i><br> @enderror
                                </div>
                            </div>
                        </div>
                        <div class="row justify-content-right">
                            <div class="text-right col-md-12">
                                <x-adminlte-button wire:click="save" theme="success" label="Save" class="btn-sm" icon="fas fa-microscope"/>
                            </div>
                        </div>   
                    </div>
                    <div class="modal-footer">
                    </div>
               </div>
            </div>
           
        </div>
    </div>
    @push('scripts')
        <script>
            window.livewire.on('superviseMeetingModal_ArSysStudentResearchSuperviseMeeting', () => {
                console.log('here');
                $('#superviseMeetingModal').modal('show');
            });
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#supervisorSuperviseMeeting').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('supervisor', dataProgram);
                    console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelecSupervisorSuperviseMeeting',()=>{
                    $('#supervisorSuperviseMeeting').select2('destroy');
                    $('#supervisorSuperviseMeeting').select2();
                    console.log('reload supervise meeting');
                });
            });

            $('#message').summernote({
                tabsize: 2,
                height: 60,
                toolbar: [
                    //['style', ['style']],
                    ['font', ['bold', 'underline', 'italic','clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    //['table', ['table']],
                    //['insert', ['link', 'video']],
                    ['insert', ['link']],
                    ['view', ['fullscreen']]
                    //['view', ['fullscreen', 'codeview', 'help']]
                ],
                callbacks: {
                    onChange: function(contents, $editable) {
                        @this.set('message', contents);
                    }
                }
            });
            window.livewire.on('resetSummernoteMessageStudentSuperviseMeeting', () => {
                console.log('here');
                $('#message').summernote('reset');
            });
            var picker = new Pikaday(
            {
                field: document.getElementById('dateOfMeeting'),
                format: 'DD/MM/YYYY',
                onSelect: function() {
                    var data = this.getDate();
                    @this.set('dateOfMeeting', data);
                    
                }
            });
        </script>
    @endpush    

</div>

