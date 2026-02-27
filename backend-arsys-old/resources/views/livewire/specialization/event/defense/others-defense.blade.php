<div>
    @if($clusterEvents->isNotEmpty())
        <div class="row">
            <div class="col-md-12 text-right offset-sm-0">
                <b>
                    Parallel events in cluster {{Auth::user()->staff->program->cluster->data->code}}
                </b>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-12 text-right offset-sm-0">
                @foreach($clusterEvents as $index => $event)
                    <u style="cursor: pointer; color:blue" wire:click="viewEventApplicant({{$event->id}})">
                    {{$index+1}}. {{$event->program->code}}: 
                    {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                    {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                    {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                    ({{$event->defenseApplicant->count()}} student)
                    </u>
                    <br>
                @endforeach
            </div>
        </div>
    @endif
    <div>
        <div wire:ignore.self class="modal fade" id="otherEventModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-lg" role="document">
               <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="otherEventModal">Applicant of parallel event</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        @if($eventApplicants->isNotEmpty())
                            <div class="row">
                                <div class="col-md-12 offset-md-0">
                                    @if($event)
                                        Schedule of {{$event->program->abbrev}}'s {{$event->type->description}} |
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                                    @endif
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-12 offset-md-0" style="width: 100%; height: 400px; overflow-y: scroll; overflow-x: hidden">
                                    <div class="table-responsive users-table">
                                        <table class="table table-striped table-sm data-table">
                                            <thead class="thead">
                                            <tr>
                                                <th></th>
                                                <th width="35%">Student</th>
                                                <th class="text-center" width="1%">SPV(s)</th>
                                                <th class="text-center" width="10%">EX(s)</th>
                                                <th class="text-left" width="15%">Session</th>
                                                <th class="text-left" width="30%">Space</th>
                                            </tr>
                                            </thead>
                                            <tbody id="users-table">
        
                                                @forelse ($eventApplicants as $index => $applicant)
                                                    <tr>
                                                        <td>{{$index+1}}.</td>
                                                        <td>
                                                            @if($applicant->research->student->program != null)
                                                                {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                                            @endif
                                                            <br>
                                                            {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
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
                                                            @else
                                                                <i style="color:red">unpublish</i>
                                                            @endif
                                                        </td>
                                                        <td class="text-left">
                                                            @if($applicant->publish == 1)
                                                                @if ($applicant->space != null)
                                                                    {{$applicant->space->code}}
                                                                    <br>
                                                                    {{--
                                                                    {{$applicant->space->description}}
                                                                    --}}
                                                                @endif
                                                            @else
                                                                <i style="color:red">unpublish</i>
                                                            @endif
                                                        </td>
        
                                                    </tr>
                                                @empty
                                                <tr>
                                                    <td colspan = "6">
                                                        No data
                                                    </td>
                                                </tr>
                                                @endforelse
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        @endif
                    </div>
               </div>
            </div>
            <script>
                window.livewire.on('otherEvent_SpecializationEventDefensePage', () => {
                    $('#otherEventModal').modal('show');
                });
            </script>
        </div>
    
    </div>
    
</div>
