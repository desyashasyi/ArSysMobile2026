<div>
    <div wire:key="arsys.student.research.components.supervise-meeting">
        <div wire:ignore.self class="modal fade" id="superviseMeetingModal_Student" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-md" role="document">
               <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="superviseMeetingModal_Student">Supervise Meeting</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body"style="width: 100%; height: 520px;">
                        <div class="row">
                            <div class="col-md-12">
                                @if(!is_null($supervise))
                                    <i>{{\Carbon\Carbon::parse($supervise->date_of_meeting)->format('d F Y')}}</i>  
                                    <br>
                                    <b style="color: green">{{$supervise->topic}}</b>
                                    <hr>
                                @endif
                            </div>
                        </div>
                        <div class="row"  style="width: 100%; height: 200px; overflow-y: scroll; overflow-x: hidden">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-12">
                                        @if(!is_null($supervise)) 
                                            
                                            {!!$supervise->message!!}
                                            <hr>
                                            @if(!is_null($supervise->discussion))
                                                @foreach ($supervise->discussion as $discussion)
                                                    <div class="row">
                                                        <div class="col-md-3 text-right">
                                                            @if(strlen($discussion->user->sso) > 7)
                                                                <b style="color: green">{{$discussion->user->staff->code}}</b>
                                                            @else
                                                            @php
                                                                $name = explode(' ', $discussion->user->student->first_name);
                                                            @endphp
                                                            <b style="color: red">{{$name[0]}}</b>
                                                            @endif
                                                        </div>
                                                        <div class="col-md-9">
                                                            <i>{{\Carbon\Carbon::parse($discussion->created_at)->format('d F Y')}}</i> 
                                                            @if($discussion->discussant_id == Auth::user()->id)
                                                                <i wire:click="delete({{$discussion->id}})" style="color:red;cursor: pointer;" class="fa fa-times-circle fa-xs"></i>
                                                            @endif
                                                            <br>
                                                            {!!$discussion->message!!}
                                                        </div>
                                                    </div>
                                                @endforeach
                                            @endif
                                        @endif
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="row justify-content-right" style="width: 100%; height: 120px; overflow-y: scroll; overflow-x: hidden">
                            <div class="col-md-12">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group" wire:ignore>
                                            <textarea type="text" wire:model="superviseMessage" input="superviseMessage" name="superviseMessage" id="superviseMessage" class="superviseMessage"></textarea>
                                            @error('superviseMessage') <i class="text-danger">{{ $message }}</i><br> @enderror
                                        </div>
                                    </div>
                                </div>
                                 
                            </div>
                        </div>
                        <hr>
                        <div class="row justify-content-right">
                            <div class="col-md-12 text-right">
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
            window.livewire.on('superviseMeetingShowModal_ArSysStudentResearchSuperviseMeeting', () => {
                $('#superviseMeetingModal_Student').modal('show');
            });
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            

            $('#superviseMessage').summernote({
                tabsize: 2,
                height: 60,
                toolbar: [
                    ['font', ['bold', 'underline', 'italic','clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol']],
                    //['para', ['ul', 'ol', 'paragraph']],
                    //['table', ['table']],
                    ['insert', ['link', 'video']],
                    //['insert', ['link']],
                    ['view', ['fullscreen']]
                ],
                callbacks: {
                    onChange: function(contents, $editable) {
                        @this.set('superviseMessage', contents);
                    }
                }
            });
            window.livewire.on('setSummernoteMessageStudentSuperviseMeeting', () => {
                $('#superviseMeetingModal_Student').modal('show');
                console.log('here');
                $('#superviseMessage').summernote('reset');
            });
          
            
        </script>
    @endpush    

</div>

