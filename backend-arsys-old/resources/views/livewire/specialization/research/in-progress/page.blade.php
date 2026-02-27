<div>
    @if($researchs->isNotEmpty())
        <div class="row text-right">
            <div class="col-md-12">
                @if(\App\Models\ArSys\Program::find(Auth::user()->staff->program_id)->researchConfig_EnableSuperviseDuration->status == 1)
                    <button wire:click="setConfig({{\App\Models\ArSys\Program::find(Auth::user()->staff->program_id)->researchConfig_EnableSuperviseDuration->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i> Disable Supervise Duration</button>
                @else
                    <button wire:click="setConfig({{\App\Models\ArSys\Program::find(Auth::user()->staff->program_id)->researchConfig_EnableSuperviseDuration->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i> Enable Supervise Duration</button>
                @endif

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
                                <th></th>
                                <th width="2%">No</th>
                                <th width="25%">Student</th>
                                <th width="30%">Title</th>
                                <th width="10%">Supervisor</th>
                                <th width="15%">Milestone</th>
                                <th width="10%" class="text-right">Supervise Duration</th>
                                <th width="10%" class="text-right">Action</th>
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
                                    <td class="bg-{{$research->type->base->color}}"></td>
                                    @if(
                                        ($research->predefenseApproved->count() != $research->predefenseApproval()->count())
                                        ||
                                        ($research->finaldefenseApproved->count() != $research->finaldefenseApproval()->count())
                                        ||
                                        ($research->seminarApproved->count() != $research->seminarApproval()->count())
                                    )
                                        <td class="bg-red"></td>
                                    @else
                                        <td></td>
                                    @endif

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
                                    <td class="text-center">
                                        @foreach ($research->supervisor as $supervisor)
                                            {{$supervisor->staff->code}}
                                            {{--
                                            <i wire:click="unAssign({{ $supervisor->id }})" class="fa fa-xs fa-user-minus" style ="color:red;cursor: pointer;" aria-hidden="true"></i>
                                            --}}
                                            <br>
                                        @endforeach
                                        @if($research->supervisorexternal)
                                            {{$research->supervisorexternal->institution}}
                                        @endif
                                    </td>
                                    <td>
                                        @if($research->milestone)
                                            <b>{{$research->milestone->code}}</b>
                                        @endif
                                        <br>
                                        @if($research->freeze)
                                            {{$research->freeze->message}}
                                        @elseif($research->renewal)
                                            {{$research->renewal->message}}
                                        @elseif($research->SIASPro && !$research->programSeminar)
                                            {{$research->SIASPro->message}}
                                        @else
                                            @if($research->milestone)
                                                {{$research->milestone->phase}}
                                            @endif
                                        @endif
                                    </td>
                                    <td class="text-center">
                                        @if($research->disableSuperviseDuration)
                                            <i wire:click="disableSuperviseDuration({{$research->id}})" style="color: gray; cursor: pointer;" class="fas fa-check-circle"></i>
                                        @else
                                            <i wire:click="disableSuperviseDuration({{$research->id}})" style="color: green; cursor: pointer;" class="fas fa-check-circle"></i>
                                        @endif
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$research->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif
                                    </td>
                                    <td></td>


                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="6">
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
                                                    <livewire:specialization.research.in-progress.view :researchId="$research->id" :wire:key="'view-'.$research->id">
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                @endif
                           @endforeach
                        </tbody>
                    </table>
                </div>
                {{$researchs->render()}}
            @else
                No data
            @endif
        </div>
    </div>
</div>
