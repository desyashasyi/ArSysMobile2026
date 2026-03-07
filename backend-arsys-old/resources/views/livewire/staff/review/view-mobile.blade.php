<div>
    <div class="row d-block d-sm-none">
        <div class="col-sm-12 offset-sm-0">
            @if(!is_null($research))
                <div class="card card-outline card-success">
                   
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-12">
                                {{$research->code}}
                                <br>
                                {{$research->title}}
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                @if($research->milestone)
                                    <b>{{$research->milestone->code}}</b>
                                @endif
                                <br>
                                @if($research->history->contains('message', 
                                    \App\Models\ArSys\ResearchLogType::where('code', 'REN')->first()->description))
                                    <span class="badge badge-pill badge-warning">Renewal</span>
                                @else
                                    @if($research->review)
                                        <hr>
                                        @foreach($research->reviewer as $reviewer)
                                            @if($reviewer->decision_id ==null)
                                                {{$reviewer->staff->code}}-Not defined
                                            @endif
                                            @if($reviewer->decision_id == 
                                                \App\Models\ArSys\ResearchReviewDecisionType::where('code', 'APP')->first()->id)
                                                <span class="badge badge-pill badge-success">
                                                    {{$reviewer->staff->code}}-{{$reviewer->decision->description}}
                                                </span>
                                            @endif
                                            @if($reviewer->decision_id == 
                                                \App\Models\ArSys\ResearchReviewDecisionType::where('code', 'RJC')->first()->id)
                                                <span class="badge badge-pill badge-danger">
                                                    {{$reviewer->staff->code}}-{{$reviewer->decision->description}}
                                                </span>
                                            @endif
                                            <br>
                                        @endforeach
                                    @endif
                                @endif            
                            </div>
                        </div>
                        <hr>
                        <div class='text-center row'>
                            <div class="col-md-12 offset-sm-0">
                                @if(\App\Models\ArSys\ResearchConfig::where('program_id', $research->student->program_id)
                                    ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                                    ->first()->status == null)
                                    <a href="{{$research->file}}" target = "_blank">File of proposal</a>
                                @elseif(\App\Models\ArSys\ResearchConfig::where('program_id', $research->student->program_id)
                                    ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                                    ->first()->status == null) 
                                    && $research->proposalFile != null)
                                    @foreach ($research->proposalFile as $file)
                                        @if ($research->proposalFile != null)
                                            <a href="{{url('/')}}{{ Storage::disk('local')->url($file->filename)}}" target="blank"><b><u>File of proposal</u></b></a>
                                        @else
                                            File missing
                                        @endif
                                    @endforeach
                                @endif
                                @if(\App\Models\ArSys\ResearchConfig::where('program_id', $research->student->program_id)
                                        ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                                        ->first()->status == 1)
                                    @foreach ($research->proposalFile as $file)
                                        @if ($research->proposalFile != null)
                                            <a href="{{url('/')}}{{ Storage::disk('local')->url($file->filename)}}" target="blank"><b><u>File of proposal</u></b></a>
                                        @else
                                            File missing
                                        @endif
                                    @endforeach
                                @endif
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <div class="text-right col-md-12 offset-sm-0">
                                <x-adminlte-button class="btn-sm" theme="success"  wire:click="accept" icon="fa fa-check-circle" aria-hidden="true" label="Approve"/>
                                <x-adminlte-button class="btn-sm" theme="danger"  wire:click="reject" icon="fa fa-ban" aria-hidden="true" label="Reject"/>
                            </div>
                        </div>
                    </div>
                </div>       
            @endif
        </div>
    </div>
</div>