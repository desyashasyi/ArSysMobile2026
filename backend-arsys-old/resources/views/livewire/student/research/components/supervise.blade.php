<div>
    @if($research)
        <div class="text-left col-md-12">
            <i class="fas fa-spinner"></i><b> Progress of Supervision</b>
                <i wire:click="superviseMeeting_ArSysStudentResearchSuperviseMeeting({{$research->id}})" style="color: green; cursor: pointer" class="fa fa-plus-circle"></i>
                <hr>
                <div x-data="{researchSupervise : @entangle('researchSupervise') }">
                    <div x-show="researchSupervise">
                        @foreach($research->supervisor as $supervisorIndex => $supervisor)
                            @if($supervisor->meeting->isNotEmpty())
                                <div class="row">
                                    <div class="text-right col-md-2">
                                        @if($supervisor->bypass == 1)
                                            <span class="badge badge-pill badge-success">
                                                <b>{{$supervisor->staff->code}}</b>
                                            </span>
                                        @else
                                            <span class="badge badge-pill badge-danger">
                                                <b>{{$supervisor->staff->code}}</b>
                                            </span>
                                        @endif
                                    </div>
                                    <div class="text-left col-md-10">
                                        @foreach($supervisor->meeting as $index => $supervise)
                                            <i>{{\Carbon\Carbon::parse($supervise->created_at)->format('d F Y')}}</i> |
                                            <i wire:click="$emit('superviseMeetingShow_ArSysStudentResearchSuperviseMeeting',{{$supervise->id}} )" style="color:green;cursor: pointer;" class="fa fa-eye fa-xs"></i>
                                            <br>
                                            {{$supervise->topic}}
                                            @if($index < $supervisor->meeting->count()-1)
                                                <hr>
                                            @endif
                                        @endforeach
                                    </div>
                                </div>
                                @if($supervisorIndex < $research->supervisor->count()-1)
                                    <hr>
                                @endif
                            @endif
                        @endforeach
                    </div>
                </div>
                @if($research->supervise->isEmpty())
                    <i style="color: red">
                        One of the mandatory rule of students'research is that student should have
                        at least six supervision meeting once a week.
                        So, please report you meeting by clicking the
                    <span style="color: gray" class="fa fa-plus-circle"></span> icon above.
                    </i>
                @endif
        </div>
    @endif
    <livewire:student.research.components.supervise-meeting">
    <livewire:student.research.components.supervise-meeting-show">
</div>
