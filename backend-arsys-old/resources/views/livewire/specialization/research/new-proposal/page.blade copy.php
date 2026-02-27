<div>
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
                                        <b>{{$research->milestone->code}}</b>
                                        <br>
                                        @if($research->renewal)
                                            {{$research->renewal->message}}
                                        @else
                                            {{$research->milestone->phase}}
                                        @endif
                                        <hr>
                                        @if(!$research->remark->contains('discussant_id', Auth::user()->id))
                                            <x-adminlte-button   wire:click="notifyStudent({{$research->id}})"
                                                theme="success" icon="fa fa-xs fa-envelope" class="btn btn-xs" label="Notify Student"/>
                                            @else
                                                <i style="color:green" class="fa fa-xs fa-check-circle">
                                                </i> Notified
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
                                        <td colspan="4">
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
                                                    @if($research->renewal)
                                                        <livewire:specialization.research.re-new.view :wire:key="'$research->id'">
                                                    @else
                                                        <livewire:specialization.research.new-proposal.view :wire:key="'$research->id'">
                                                    @endif
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
