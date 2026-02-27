<div>
    <div wire:ignore.self class="modal fade" id="staffExaminerScoreModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="staffExaminerScoreModal">Student's Defense/Seminar Score</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <b>Guidance of Defense/Seminar Score</b>
                    @if($scoreGuide != null)
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
                        <hr>
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
                                {{-- With prepend slot, sm size and label --}}
                                <x-adminlte-textarea wire:model="remark" name="remark" label="Defense note" rows=5
                                    igroup-size="sm" placeholder="Insert defense note...">
                                </x-adminlte-textarea>
                                @error('remark')
                                    <span class="text-danger">{{ $message }}</span><br>
                                @enderror
                            </div>
                        </div>
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
    </script>
</div>


<div>
    
</div>