<div>
    <div class="row">
        <div class="text-right col-md-12 offset-md-0">
            {{--
            <div x-data="{ addResearch: @entangle('addResearch') }">
                @if (!$addResearch)
                    <div class="row">
                        <div class="text-right col-md-12">
                            <x-adminlte-button wire:click="addResearch_ArSysStudentResearchPage" theme="success"
                                icon="fa fa-plus-circle" class="btn btn-sm" label="Add research" />
                        </div>
                    </div>
                @endif
                <div x-show="addResearch">
                    <livewire:student.research.create :wire:key="'arsys.student.research.create'">
                </div>
            </div>
            --}}
            <livewire:student.research.create/>
            here
        </div>
    </div>
    <br>
    <div class="row">
        <div class="text-left col-md-12">
            @if ($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="20%">Student</th>
                                <th width="40%">Title</th>
                                <th class="text-center" width="10%">Rev/Spv</th>
                                <th width="15%">Milestone</th>
                                <th class="text-right" width="10%"">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if ($index % 2 == 0)
                                    <tr class="bg-light">
                                    @else
                                    <tr>
                                @endif
                                <td>{{ $index + 1 }}</td>
                                <td>
                                    {{ $research->student->first_name }} {{ $research->student->last_name }}
                                    <br>
                                    {{ $research->student->program->code }}.{{ $research->student->number }}
                                </td>
                                <td>{{ $research->code }}-{{ $research->id }}
                                    <br>
                                    {{ $research->title }}

                                </td>
                                <td class="text-center">

                                    @if($research->review)
                                        @foreach ($research->reviewer as $reviewer)
                                            {{ $reviewer->staff->code }}
                                            <br>
                                        @endforeach

                                    @else
                                        @if($research->supervisor->isNotEmpty())
                                            @foreach ($research->supervisor as $supervisor)
                                                {{ $supervisor->staff->code }}
                                                <br>
                                            @endforeach
                                        @endif
                                        @if($research->supervisorexternal)
                                            {{$research->supervisorexternal->institution}}
                                        @endif
                                    @endif
                                </td>
                                <td>

                                    @if($research->milestone)
                                        <b>{{ $research->milestone->code }}</b>
                                    @endif
                                    <br>
                                    @if ($research->freeze)
                                        {{ $research->freeze->message }}
                                    @elseif($research->renewal)
                                        {{ $research->renewal->message }}
                                    @elseif($research->SIASPro && !$research->programSeminar)
                                        {{ $research->SIASPro->message }}
                                    @elseif($research->rejected)
                                        {{ $research->rejected->message }}
                                    @else
                                        @if($research->milestone)
                                            {{ $research->milestone->phase }}
                                        @endif
                                    @endif
                                    <hr>
                                    @if($research->reviewer->isNotEmpty())
                                        @foreach($research->reviewer as $reviewer)
                                            @if($reviewer->decision_id ==
                                                \App\Models\ArSys\ResearchReviewDecisionType::where('code', 'RJC')->first()->id)
                                                <span class="badge badge-pill badge-danger">
                                                    {{$reviewer->staff->code}}-{{$reviewer->decision->description}}
                                                </span>
                                            @endif
                                         @endforeach
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
                                </tr>

                                @if ($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            @if (!($research->freeze || $research->renewal || $research->SIASPro || $research->rejected))
                                                @if (!$research->active)
                                                    <div class='text-center row'>
                                                        <div class="col-md-12 offset-sm-0">
                                                            @if (\App\Models\ArSys\ResearchConfig::where('program_id', Auth::user()->student->program_id)->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)->first()->status == null)
                                                                File of proposal could be access <a
                                                                    href="{{ $research->file }}" target="_blank"> here </a>
                                                            @elseif(\App\Models\ArSys\ResearchConfig::where('program_id', Auth::user()->student->program_id)->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)->first()->status == null)
                                                                &&
                                                                $research->proposalFile != null)
                                                                @foreach ($research->proposalFile as $file)
                                                                    @if ($research->proposalFile != null)
                                                                        File of proposal could be accessed <a
                                                                            href="{{ url('/') }}{{ Storage::disk('local')->url($file->filename) }}"
                                                                            target="blank"><b><u>here</u></b></a>
                                                                    @else
                                                                        File missing
                                                                    @endif
                                                                @endforeach
                                                            @endif
                                                            @if (\App\Models\ArSys\ResearchConfig::where('program_id', Auth::user()->student->program_id)->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)->first()->status == 1)
                                                                @foreach ($research->proposalFile as $file)
                                                                    @if ($research->proposalFile != null)
                                                                        File of proposal could be accessed <a
                                                                            href="{{ url('/') }}{{ Storage::disk('local')->url($file->filename) }}"
                                                                            target="blank"><b><u>here</u></b></a>
                                                                    @else
                                                                        File missing
                                                                    @endif
                                                                @endforeach
                                                            @endif
                                                        </div>
                                                    </div>
                                                    <br>
                                                @endif
                                            @endif
                                            <div x-data="{ viewResearch: @entangle('viewResearch') }">
                                                <div x-show="viewResearch">
                                                    <div class="row">
                                                        <div class="text-right col-md-12">
                                                            <livewire:student.research.view :researchId="$research->id" :wire:key="'view-'.$research->id">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="text-right col-md-12">
                                                            <livewire:components.research.remark :researchId="$research->id" :wire:key="'remark-'.$research->id">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                @endif
                            @endforeach
                        </tbody>
                    </table>
                    {{ $researchs->render() }}
                </div>
            @else
                No data
            @endif
        </div>
    </div>
    <x-flatpickr::script />
</div>
