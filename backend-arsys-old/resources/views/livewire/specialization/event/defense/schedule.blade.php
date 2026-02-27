<div>
    <div>
        @if($event->status == 1)
        <x-adminlte-button   wire:click="captureSchedule" 
        theme="success" icon="fa fa-xs fa-camera" class="btn btn-outline btn-xs" label="Capture schedule"/> 
        @endif
    </div>
   
    <div>
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
                        @if($applicants->isNotEmpty())
                            <div class="row">
                                <div class="col-md-12 offset-md-0" style="width: 100%; height: 400px; overflow-y: scroll; overflow-x: hidden">
                                    <div class="table-responsive users-table">
                                        <table class="table table-striped table-sm data-table">
                                            <thead class="thead">
                                            <tr>
                                                <th></th>
                                                <th width="20%" class="text-left">Student</th>
                                                <th width="40%" class="text-left">Research</th>
                                                <th class="text-center" width="10%">SPV(s)</th>
                                                <th class="text-center" width="10%">EX(s)</th>
                                                <th class="text-left" width="20%">Session and space</th>
                                            </tr>
                                            </thead>
                                            <tbody id="users-table">
                                               
                                                @foreach ($applicants as $index => $applicant)
                                                <tr>
                                                    <td>
                                                        {{$index+1}}
                                                    </td>
                                                    <td class="text-left">
                                                        @if($applicant->research->student->program != null)
                                                            {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                                        @endif
                                                        <br>
                                                        {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                                    </td>
                                                    <td class="text-left"> 
                                                        <b>{{$applicant->research->code}}</b>
                                                        <br>
                                                        {!!$applicant->research->title!!}
                                                    </td>
                                                    <td class="text-center">
                                                        @if($applicant->research->supervisor != null)
                                                            @forelse ($applicant->research->supervisor as $supervisor)
                                                                {{$supervisor->staff->code}}
                                                                <br>
                                                            @empty
                                                            @endforelse
                                                        @endif
                                                    </td>
    
                                                    <td class="text-center">
                                                        @if($applicant->publish == 1)
                                                            @foreach ($applicant->examiner as $examiner)
                                                                {{$examiner->staff->code}}
                                                                <br>
                                                            @endforeach
                                                        @else
                                                            <i style="color:red">unpublish</i>
                                                        @endif
                                                    </td>
                                                    <td class="text-left">
                                                        @if($applicant->publish == 1)
                                                            @if($applicant->session != null)
                                                                {{$applicant->session->time}}
                                                            @endif
                                                            <br>
                                                            @if ($applicant->space != null)
                                                                {{$applicant->space->code}}
                                                                <br>
                                                            
                                                            @endif
                                                        @else
                                                            <i style="color:red">unpublish</i>
                                                        @endif
                                                    </td>
                                                </tr>
                                                @endforeach
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        @else
                            No data
                        @endif
                    </div>
               </div>
            </div>
            <script>
                window.livewire.on('captureSchedule_SpecializationEventDefensePage', () => {
                    $('#captureScheduleModal').modal('show');
                });
            </script>
        </div>
    
    </div>
    
</div>
