<div>
    @if($researchs->isNotEmpty())
        <div class="row">
            <div class="text-right col-md-12">
                <x-adminlte-button name="sendTelegramMessage" wire:click="sendTelegramMessage" theme="success" icon="fa fa-paper-plane" class="btn btn-sm" label="Send Telegram Reminder"/>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-4">
                <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
            </div>
            <div class="my-2 col-md-8">
                @foreach ($researchTypes as $type)
                    <span class="badge bg-{{$type->base->color}}">{{$type->base->code}}-{{$type->base->description}}</span>
                    &nbsp;
                @endforeach
            </div>
        </div>
    @endif

    <div class="row">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th></th>
                                <th width="5%">No</th>
                                <th width="20%">Student</th>
                                <th width="50%">Title</th>
                                <th width="15%">Milestone</th>
                                <th class="text-right" width="10%">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td class="bg-{{$research->type->base->color}}"></td>

                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                    </td>
                                    <td>
                                        {{$research->code}}-{{$research->id}}
                                        <br>
                                        {{$research->title}}
                                    </td>
                                    <td>
                                        @if($research->milestone)
                                            <b>{{$research->milestone->code}}</b>
                                        @endif
                                        <br>
                                        @if($research->renewal)
                                            {{$research->renewal->message}}
                                        @else
                                            @if($research->milestone)
                                                {{$research->milestone->phase}}
                                            @endif
                                        @endif
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
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$research->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif
                                    </td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="5">
                                            <div class='text-center row'>
                                                <div class="col-md-12 offset-sm-0">
                                                    @if(\App\Models\ArSys\ResearchConfig::where('program_id', $research->student->program_id)
                                                        ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                                                        ->first()->status == null)
                                                        File of proposal could be access <a href="{{$research->file}}" target = "_blank"> here </a>
                                                    @elseif(\App\Models\ArSys\ResearchConfig::where('program_id', $research->student->program_id)
                                                        ->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)
                                                        ->first()->status == null)
                                                        && $research->proposalFile != null)
                                                        @foreach ($research->proposalFile as $file)
                                                            @if ($research->proposalFile != null)
                                                                File of proposal could be accessed <a href="{{url('/')}}{{ Storage::disk('local')->url($file->filename)}}" target="blank"><b><u>here</u></b></a>
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
                                                                File of proposal could be accessed <a href="{{url('/')}}{{ Storage::disk('local')->url($file->filename)}}" target="blank"><b><u>here</u></b></a>
                                                            @else
                                                                File missing
                                                            @endif
                                                        @endforeach
                                                    @endif
                                                </div>
                                            </div>
                                            <br>
                                            <div x-data="{viewResearch : @entangle('viewResearch') }">
                                                <div x-show="viewResearch">
                                                    <livewire:specialization.research.being-reviewed.view :researchId="$research->id" :wire:key="'being-reviewed.view-'.$research->id">
                                                    <livewire:specialization.research.components.remark :researchId="$research->id" :wire:key="'remark-'.$research->id">
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                @endif
                           @endforeach
                        </tbody>
                    </table>
                    {{$researchs->links()}}
                </div>
            @else
                No data
            @endif
        </div>
    </div>
</div>
