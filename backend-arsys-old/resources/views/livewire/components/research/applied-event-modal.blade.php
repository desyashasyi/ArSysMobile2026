<div wire:ignore.self class="modal fade" id="arsysComponentsResearchAppliedEventModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
       <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="arsysComponentsResearchAppliedEventModal">Sheduled
                    @if($event)
                        of {{$event->type->description}} |
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
                @if($applicants != null)
                    <div class="row">
                        <div class="col-md-12 offset-md-0" style="width: 100%; height: 400px; overflow-y: scroll; overflow-x: hidden">
                            <div class="table-responsive users-table">
                                <table class="table table-striped table-sm data-table">
                                    <thead class="thead">
                                    <tr>
                                        <th></th>
                                        <th width="25%">Student</th>
                                        <th width="35%">Research</th>
                                        <th class="text-center" width="10%">SPV(s)</th>
                                        <th class="text-center" width="10%">EX(s)</th>
                                        <th class="text-center" width="25%">Schedule</th>
                                    </tr>
                                    </thead>
                                    <tbody id="users-table">

                                        @forelse ($applicants as $index => $applicant)
                                            <tr>
                                                <td>{{$index+1}}.</td>
                                                <td>
                                                    @if($applicant->research->student->program != null)
                                                        {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                                    @endif
                                                    <br>
                                                    {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                                </td>
                                                <td>
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
                                                <td class="text-center">
                                                    @if($applicant->publish == 1)
                                                        @if($applicant->session != null)
                                                            {{$applicant->session->time}}
                                                        @endif
                                                        <br>
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
                    {{$applicants->links()}}
                @endif
            </div>
            <div class="modal-footer">
            </div>

       </div>
    </div>
</div>
<script>
    window.livewire.on('arsysComponentsResearchAppliedEvent', () => {
        $('#arsysComponentsResearchAppliedEventModal').modal('show');
    });
</script>