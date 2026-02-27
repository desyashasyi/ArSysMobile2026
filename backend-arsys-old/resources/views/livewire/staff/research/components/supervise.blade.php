<div>
                        
    <div wire:key="arsys.staff.research.components.supervise">
        <div x-data="{viewSupervise : @entangle('viewSupervise') }">
            <div x-show="viewSupervise">
                <div class="row">
                    <div class="col-md-12 text-left">
                        <i class="fas fa-spinner"></i><b> Progress of Supervision </b>
                        <hr>
                        @if($research)
                            {{$research->id}}
                            @if($research->supervise->isNotEmpty())
                                <div x-data="{researchSupervise : @entangle('researchSupervise') }">
                                    <div x-show="researchSupervise">
                                        @foreach($research->supervisor as $supervisor)
                                            @if($supervisor->meeting->isNotEmpty())
                                                <div class="row">
                                                    <div class="col-md-2 text-right">
                                                        @if($supervisor->bypass == 1)
                                                            @if($supervisor->staff->id == Auth::user()->staff->id)
                                                                <span style="cursor: pointer;" wire:click="bypass({{$supervisor->id}})" class="badge badge-pill badge-success">
                                                            @else
                                                                <span class="badge badge-pill badge-success">
                                                            @endif
                                                                <b>{{$supervisor->staff->code}}</b>
                                                            </span>
                                                        @else
                                                            @if($supervisor->staff->id == Auth::user()->staff->id)
                                                                <span style="cursor: pointer;" wire:click="bypass({{$supervisor->id}})" class="badge badge-pill badge-danger">
                                                            @else
                                                                <span class="badge badge-pill badge-danger">
                                                            @endif
                                                                <b>{{$supervisor->staff->code}}</b>
                                                            </span>
                                                        @endif
                                                    </div>
                                                    <div class="col-md-10 text-left">
                                                        @foreach($supervisor->meeting as $supervise)
                                                            <i>{{\Carbon\Carbon::parse($supervise->created_at)->format('d F Y')}}</i>
                                                            @if(\App\Models\ArSys\ResearchConfig::where('program_id', $supervise->research->student->program_id)
                                                                ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'SHARING_OF_SUPERVISE_MEETING')->first()->id)
                                                                ->first()->status == 1)
                                                                <i wire:click="$emit('superviseMeetingShow_ArSysStaffResearchSuperviseMeeting', {{$supervise->id}})" style="color:green;cursor: pointer;" class="fa fa-eye fa-sm"></i> 
                                                            @else
                                                            <i wire:click="$emit('superviseMeetingShow_ArSysStaffResearchSuperviseMeeting', {{$supervise->id}})" style="color:green;cursor: pointer;" class="fa fa-eye fa-sm"></i> 
                                                            @endif
                                                            @if($supervisor->staff->id == Auth::user()->staff->id)
                                                                | 
                                                                @if(is_null($supervise->status))
                                                                    <i style="color:gray;cursor: pointer;" wire:click="approveMeeting({{$supervise->id}})" class="fa fa-check-circle fa-sm"></i>
                                                                @else
                                                                    <i style="color:green;cursor: pointer;" wire:click="approveMeeting({{$supervise->id}})" class="fa fa-check-circle fa-sm"></i>
                                                                @endif
                                                        
                                                            @endif
                                                            <br>
                                                            {{$supervise->topic}}
                                                            <br>
                                                        @endforeach
                                                    </div>
                                                </div>
                                            @endif
                                            <hr>
                                        @endforeach
                                        
                                    </div>
                                </div>
                            @else
                                Students' has not create meeting report
                            @endif
                        @endif
                    </div>
                </div>
            </div>
        </div> 
    </div>   
</div>
