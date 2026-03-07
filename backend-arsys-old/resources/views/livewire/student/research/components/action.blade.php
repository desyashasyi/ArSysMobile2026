<div>
    @if($research)
        <div class="row">
            <div class="col-sm-12">
                @if(!$research->reject)
                    @if(!$delete)
                        <x-adminlte-button wire:click="$emit('editResearch_ArSysStudentResearchEdit',{{$research->id}})" label="Edit" class="btn-xs" theme="warning" icon="fas fa-edit"/>
                        @if($research->write)
                            <x-adminlte-button wire:click="delete" label="Delete" class="btn-xs" theme="danger" icon="fas fa-trash"/>
                            <x-adminlte-button wire:click="researchProposal({{$researchId}})" label="Submit Proposal" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif
                    @endif
                @endif

                @if($delete)
                    @if ($researchId == $research->id)
                        <x-adminlte-button wire:click="deleteProceed({{$researchId}})" label="Are you sure?" class="btn-xs" theme="danger"/>
                        <x-adminlte-button wire:click="deleteCancel" label="Cancel" class="btn-xs" theme="success"/>
                    @endif
                @endif
                {{--defense --}}

                @if($research->active)

                    @if($research->milesPredefenseProgress)
                        @if($research->type->enable_week_of_supervise == 1 && is_null($research->renewed))
                            @if(\Carbon\Carbon::parse($research->active->created_at)
                                ->addDays($research->type->week_of_supervise * 7)->lte(\Carbon\Carbon::now()))
                                <x-adminlte-button wire:click="preDefenseProposal({{$researchId}})" label="Propose Pre Defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                            @elseif(\Carbon\Carbon::parse($research->active->created_at)
                                ->addDays($research->type->week_of_supervise * 7)->gte(\Carbon\Carbon::now())
                                && $research->disableSuperviseDuration)
                                <x-adminlte-button wire:click="preDefenseProposal({{$researchId}})" label="Propose Pre Defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                            @endif
                        @else
                            <x-adminlte-button wire:click="preDefenseProposal({{$researchId}})" label="Propose Pre-defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif
                    @endif


                    @if($research->predefenseApproval->isNotEmpty())
                        @if(!$research->predefenseApproval->contains('decision', null))
                            @if(!$research->predefenseApplied)
                                <x-adminlte-button wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})" label="Apply Pre-defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                            @endif
                        @endif
                    @endif


                    {{--SEMINAR--}}
                    @if($research->milesSeminarProgress)
                        @if($research->type->enable_week_of_supervise == 1)
                            @if(\Carbon\Carbon::parse($research->active->created_at)
                                ->addDays($research->type->week_of_supervise * 7)->lte(\Carbon\Carbon::now()))
                                <x-adminlte-button wire:click="seminarProposal({{$researchId}})" label="Propose Seminar" class="btn-xs" theme="success" icon="fas fa-upload"/>
                            @elseif(\Carbon\Carbon::parse($research->active->created_at)
                                ->addDays($research->type->week_of_supervise * 7)->gte(\Carbon\Carbon::now())
                                && $research->disableSuperviseDuration)
                                <x-adminlte-button wire:click="seminarProposal({{$researchId}})" label="Propose Seminar" class="btn-xs" theme="success" icon="fas fa-upload"/>
                            @endif
                        @else
                            <x-adminlte-button wire:click="seminarProposal({{$researchId}})" label="Propose Seminar" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif
                    @endif

                    @if($research->milesSeminarApproved)
                        @if(!$research->seminarApplied)
                            <x-adminlte-button wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})" label="Apply Seminar" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif
                    @endif


                    @if($research->milesFinaldefenseProgress)
                            <x-adminlte-button wire:click="finalDefenseProposal({{$researchId}})" label="Propose Final Defense" class="btn-xs" theme="success" icon="fas fa-upload"/>

                        @if(\Carbon\Carbon::parse($research->predefenseApplied->event->event_date)
                        ->addDays(4)->lte(\Carbon\Carbon::now()))
                            <x-adminlte-button wire:click="finalDefenseProposal({{$researchId}})" label="Propose Final Defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif

                    @endif
                    @if($research->milesFinaldefenseApproved)
                        @if(!$research->finaldefenseApplied)
                            <x-adminlte-button wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})" label="Apply Final defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                        @endif
                    @endif

                @endif

                @if($research->milesPREDEFDONE)
                    <x-adminlte-button wire:click="$emit('report_ArSysStudentResearch',{{$researchId}},'Defense')" label="Report Pre-defense" class="btn-xs" theme="success" icon="fas fa-upload"/>
                @endif
            </div>
        </div>
    <livewire:student.research.edit>
    <livewire:student.research.components.apply-event>
    <livewire:student.research.components.report>
    <livewire:components.telegram.send-message>
    @endif
</div>
