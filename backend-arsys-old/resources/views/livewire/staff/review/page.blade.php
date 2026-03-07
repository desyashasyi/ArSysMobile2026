<div>
    <div class="row d-none d-md-block">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="20%">Student</th>
                                <th width="50%">Title</th>
                                <th width="15%">Milestone</th>
                                <th class="text-right" width="10%">Action</th>
                                <th width="1%">&nbsp;</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                    </td>
                                    <td class='row'>
                                        {{$research->code}}
                                        <br>
                                        {{$research->title}}
                                    </td>
                                    <td>
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
                                    </td>
                                    <td class="text-right">
                                        @if (!$expandViewIndex[$index])
                                            <x-adminlte-button
                                                wire:click="expandView({{ $index }}, {{ $research->id }})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs"
                                                label="View" />
                                        @endif
                                    </td>
                                    <td></td>
                                </tr>
                                @if($expandViewIndex[$index])
                                <tr>
                                    <td></td>
                                    <td colspan="4">
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
                                        <div x-data="{viewResearch : @entangle('viewResearch') }">
                                            <div x-show="viewResearch">
                                                <livewire:staff.review.view :researchId="$research->id" :wire:key="'arsys.staff.research.view'">
                                                <livewire:specialization.research.components.remark :wire:key="'$researchId'">
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
