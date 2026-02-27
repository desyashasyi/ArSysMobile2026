<div>
    <div wire:ignore.self class="modal fade" id="report_ArSysStudentResearchModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="report_ArSysStudentResearchModal">
                        @if($mode == "Defense")
                            Report of Defense
                        @endif
                        @if($mode == "Seminar")
                            Report of Seminar
                        @endif
                    </h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div>
                        @if($defense)
                            <div class="row">
                                <div class="col-sm-2 text-right">
                                    <b>Research ID:</b>
                                </div>
                                <div class="col-sm-9">
                                    {{$defense->research->code}}
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-2 text-right">
                                    <b>Title</b>
                                </div>
                                <div class="col-sm-9">
                                    {{$defense->research->title}}
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-2 text-right">
                                    <b>Supervisor:</b>
                                </div>
                                <div class="col-sm-9">
                                    @if($defense->research->supervisor != null)
                                        @foreach($defense->research->supervisor as $supervisor)
                                            {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                            <br>
                                        @endforeach
                                    @endif
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-2 text-right">
                                    <b>Examiner:</b>
                                </div>
                                <div class="col-sm-9">
                                    @if($defense->examiner != null)
                                        @foreach ($defense->examiner as $examiner)
                                            @if($examiner->defenseExaminerPresence)
                                                {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                <br>
                                            @endif
                                        @endforeach
                                    @endif
                                </div>
                            </div>
                            <hr>
                        @endif
                    </div>
                    <div>
                        <div class="row">
                            <div class="text-left col-md-12">
                                <div class="form-group" wire:ignore>
                                    <textarea type="text" wire:model="messageReport" input="messageReport" name="messageReport" id="messageReport" class="messageReport">{{$messageReport}}</textarea>
                                </div>
                                @error('messsageReport')
                                    <span class="text-danger">{{ $messageReport }}</span><br>
                                @enderror
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 text-right">
                            <x-adminlte-button wire:click="saveReport" label="Submit report" class="btn-xs" theme="success" icon="fas fa-save"/>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('report_ArSysStudentResearchModal', () => {
            $('#report_ArSysStudentResearchModal').modal('show');
        });
        $('#messageReport').summernote({
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
                    @this.set('messageReport', contents);
                }
            }
        });
    </script>
</div>
