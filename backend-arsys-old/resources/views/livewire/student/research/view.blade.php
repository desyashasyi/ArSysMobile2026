<div>
    <div class="row">
        <div class="col-sm-12 offset-sm-0">
            @if($research)
                @if(!($research->freeze || $research->renewal || ($research->SIASPro && !$research->programSeminar) || $research->rejected))
                    <div class="row">
                        <div class="col-sm-12 offset-sm-0">
                            <div class="card card-outline card-success">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-12 offset-sm-0">
                                            <div class="row">
                                                <div class="col-md-7 border-right">

                                                    <div class='row'>
                                                        <div class="col-md-12 offset-sm-0 text-left">
                                                            <livewire:components.research.information :researchId="$research->id" :wire:key="'information-'.$research->id">
                                                            {{--
                                                            <livewire:components.research.supervise :researchId="$research->id" :wire:key="'supervise-'.$research->id">
                                                            --}}
                                                        </div>
                                                    </div>
                                                    <div class='row'>
                                                        <div class="col-md-12 offset-sm-0 text-left">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-5">
                                                    <div class='row'>
                                                        <div class="col-md-12 offset-sm-0 text-left">
                                                            <livewire:student.research.components.action  :researchId="$research->id" :wire:key="'action-'.$research->id">
                                                            <hr>
                                                            <livewire:components.research.approval  :researchId="$research->id" :wire:key="'approval'.$research->id">
                                                            <livewire:components.research.applied-event  :researchId="$research->id" :wire:key="'applied-event-'.$research->id">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                @else
                    @if ($research->freeze)
                        @include('livewire.student.research.warning.freeze')
                    @elseif($research->renewal)
                        @include('livewire.student.research.warning.renewal')
                    @elseif($research->SIASPro)
                        @include('livewire.student.research.warning.sias-proposal')
                    @elseif($research->rejected)
                        @include('livewire.student.research.warning.rejected')
                    @endif
                @endif
            @endif
        </div>
    </div>
</div>

