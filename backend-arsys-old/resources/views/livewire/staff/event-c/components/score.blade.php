<div>
    <div wire:ignore.self class="modal fade" id="staffExaminerScoreModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="staffExaminerScoreModal">Student's Defense/Seminar Score HERE</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <span wire:click="showGuidance"style="color:blue;cursor: pointer;"><u><b>Guidance of Defense/Seminar Score</b></u></span> <i>(tap/click to open)</i>
                    @if(!is_null($scoreGuide) && !is_null($showGuidance))
                        <div class="row">
                            <div class="col-md-12 offset-md-0" style="width: 100%; height: 100px; overflow-y: scroll; overflow-x: hidden">
                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <thead class="thead">
                                        <tr>
                                            <th width="15%">Code</th>
                                            <th width="30%">Value</th>
                                            <th width="45%">Description</th>
                                        </tr>
                                        </thead>
                                        <tbody id="users-table">
                                            @foreach($scoreGuide as $score)
                                                <tr>
                                                    <td>
                                                        {{$score->code}}
                                                    </td>
                                                    <td>
                                                        {{$score->value}}
                                                    </td>
                                                    <td>
                                                        {{$score->description}}
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    @endif
                        <hr>
                        <div class="row">
                            <div class="col-md-12 offset-md-0">
                                @if(!is_null($examiner))
                                    @if($examiner->event->event_type_id ==
                                        \App\Models\ArSys\EventType::where('examination_type', 'Defense')->first()->id)
                                        @if($examiner->defenseApplicant->research->student->program != null)
                                            {{$examiner->defenseApplicant->research->student->program->code}}.{{$examiner->defenseApplicant->research->student->number}}
                                            | {{$examiner->defenseApplicant->research->student->first_name}} {{$examiner->defenseApplicant->research->student->last_name}}
                                            <br>
                                            {{$examiner->defenseApplicant->research->code}} 
                                            | 
                                            <i>{!!$examiner->defenseApplicant->research->title!!}</i>

                                        @endif
                                    @endif
                                @endif
                            </div>
                        </div>
                        {{--
                        <div class="row">
                            <div class="col-md-12 offset-md-0">
                                <b>Score:</b> 
                                @if(!is_null($examiner))
                                    @if($examiner->event->event_type_id ==
                                            \App\Models\ArSys\EventType::where('examination_type', 'Defense')->first()->id)
                                        @if(is_null($examiner->defenseExaminerPresence->score))
                                            NULL
                                        @else
                                            {{$examiner->defenseExaminerPresence->score}}
                                        @endif
                                    @endif
                                @endif
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 offset-md-0">
                                <b>Remark:</b>
                                @if(!is_null($examiner))
                                    @if($examiner->event->event_type_id ==
                                            \App\Models\ArSys\EventType::where('examination_type', 'Defense')->first()->id)
                                        @if(is_null($examiner->defenseExaminerPresence->remark))
                                            NULL
                                        @else
                                            {{$examiner->defenseExaminerPresence->remark}}
                                        @endif
                                    @endif
                                @endif
                            </div>
                        </div>
                        --}}
                        <br>
                        <div class="row">
                            <div class="col-md-4">
                                <b>Revision approval</b>
                            </div>
                        </div>
                       <div class="row">
                            <div class="col-md-2">
                                <input wire:click="decision('supervisor')" type="radio" name="flexRadioDefault" id="flexRadioDefault1">
                                <label class="form-check-label" for="flexRadioDefault1">
                                  by Supervisor
                                </label>
                            </div>
                            <div class="col-md-2">
                                <input wire:click="decision('examiner')" type="radio" name="flexRadioDefault" id="flexRadioDefault1">
                                <label class="form-check-label" for="flexRadioDefault1">
                                  by Examiner
                                </label>
                            </div>
                        </div>
                        <br>
                        @if($examinerScoreRubrics)
                            <div class="row">
                                <div class="col-md-12">
                                    <table class="table">
                                        <tbody>
                                            @foreach ($examinerScoreRubrics as $index => $exRubric)
                                                <tr>
                                                    <td class="my-2" width="85%">
                                                        {{$exRubric->rubric->base->item}}
                                                    </td>
                                                    <td width="15%">
                                                        <input wire:model="search" type="text" class="my-1 form-control" placeholder="">
                                                    </td>
                                                </tr>
                                            
                                            @endforeach
                                            <tr>
                                                <td width="90%">Total</td>
                                                <td width="10%">Score</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        @endif
                        <div class="row">
                            <div class="text-left col-md-12">
                                <div class="form-group" wire:ignore>
                                    <textarea type="text" wire:model="message" input="message" name="message" id="message" class="message"></textarea>
                                </div>
                            </div>
                        </div>
                        {{--
                        <div class="row">
                            <div class="col-md-8">
                                <x-adminlte-input wire:model="defenseScore" placeholder="Input score" name="score" label="Score" style="width: 100%"/>
                                @error('defenseScore')
                                    <span class="text-danger">{{ $message }}</span><br>
                                @enderror
                            </div>  
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <x-adminlte-textarea wire:model="remark" name="remark" label="Defense note" rows=5
                                    igroup-size="sm" placeholder="Insert defense note...">
                                </x-adminlte-textarea>
                                @error('remark')
                                    <span class="text-danger">{{ $message }}</span><br>
                                @enderror
                            </div>
                        </div>
                        --}}
                        @if((!is_null($bySupervisor)) || (!is_null($byExaminer)))
                            SHOW
                        @endif
                </div>
                <div class="modal-footer">
                    <div class="row">
                        <div class="text-left col-md-12">
                            @if(!is_null($examiner))
                                @if($examiner->event->event_type_id ==
                                    \App\Models\ArSys\EventType::where('examination_type', 'Defense')->first()->id)
                                    <x-adminlte-button wire:click="submitDefenseScore" theme="success" class="btn-sm" label="Submit" icon="fa fa-save"/>
                                @endif
                            @endif
                        </div>
                    </div>
                </div>
    
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('set_ArSysStaffExaminerScoreModal', () => {
            $('#staffExaminerScoreModal').modal('show');
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
        window.addEventListener('setSummernoteMessageStudentRemark', event => {
            $("#message").set('message', contents);
        });
    </script>
</div>


<div>
    
</div>