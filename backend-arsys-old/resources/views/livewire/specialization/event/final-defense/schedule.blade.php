<div>
    <div>
        @if($event->status == 1)
        <x-adminlte-button   wire:click="captureSchedule" 
        theme="success" icon="fa fa-xs fa-camera" class="btn btn-outline btn-xs" label="Capture schedule"/> 
        @endif
    </div>
   
    <div class="text-left">
        <div wire:ignore.self class="modal fade" id="captureScheduleModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-xl" role="document">
               <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="captureScheduleModal"> 
                            @if($event)
                                Schedule of {{$event->program->abbrev}}'s {{$event->type->description}} |
                                {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                                {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                                {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                            @endif
                        </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        @if($rooms->isNotEmpty())
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <thead class="thead">
                                        <tr>
                                            <th width="5%">Id</th>
                                            <th width="25%">Schedule</th>
                                            <th width="25%">Examiner</th>
                                            <th width="40%">Applicants</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($rooms as $room)
                                            <tr>
                                                <td>
                                                    P-{{$rooms->currentPage()}}
                                                </td>
                                                <td>
                                                    <span>
                                                        <i  class="fa fa-xs fa-building" ></i>
                                                        <u>Space</u>
                                                    </span>
                                                    <br>
                                                    @if($room->space)
                                                        {{$room->space->description}}
                                                    @endif
                                                    <hr>
                                                    <span>
                                                        <i  class="fa fa-xs fa-clock" ></i>
                                                        <u>Session</u>
                                                    </span>
                                                    <br>
                                                    @if($room->session)
                                                        {{$room->session->time}}
                                                    @endif

                                                </td>
                                                <td>
                                                    <span>
                                                        <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                                        <u>Moderator</u>
                                                    </span>
                                                    <br>
                                                    @if(!is_null($room->moderator))
                                                        {{$room->moderator->first_name}} {{$room->moderator->last_name}}
                                                    @endif
                                                    <hr>
                                                    <span>
                                                        <i style="color:green" class="fas fa-xs fa-user-circle" ></i>
                                                        <u>Examiner(s)</u>
                                                    </span>
                                                    <br>
                                                    @foreach($room->examiner as $index => $examiner)
                                                        {{$examiner->staff->first_name}} {{$examiner->staff->last_name}}
                                                        <br>
                                                    @endforeach
                                                </td>
                                                <td>
                                                    @foreach($room->applicant as $index => $applicant)
                                                        @if($applicant->research->student->program_id != Auth::user()->staff->program->id)
                                                            <span style="color:gray">
                                                                {{$index+1}}.
                                                                {{$applicant->research->student->first_name}}
                                                                {{$applicant->research->student->last_name}}
                                                                ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                            </span>
                                                        @else
                                                            {{$index+1}}.
                                                            {{$applicant->research->student->first_name}}
                                                            {{$applicant->research->student->last_name}}
                                                            ({{$applicant->research->student->program->code}}-{{$applicant->research->student->program->abbrev}})
                                                        @endif
                                                        <br>
                                                    @endforeach
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                           
                            <div class="row">
                                <div class="col-md-6 offset-sm-0">
                                    {{$rooms->render()}}
                                </div>
                                <div class="text-right my-4 col-md-6 offset-sm-0">
                                    <x-adminlte-button   wire:click="downloadPDF" 
                                    theme="success" icon="fa fa-xs fa-download" class="btn btn-outline btn-xs" label="PDF"/>
                                </div>
                            </div>    
                                
                           
                        @else
                            No data
                        @endif
                    </div>
               </div>
            </div>
            <script>
                window.livewire.on('captureSchedule_SpecializationEventFinalDefensePage', () => {
                    $('#captureScheduleModal').modal('show');
                });
            </script>
        </div>
    
    </div>
    
</div>
