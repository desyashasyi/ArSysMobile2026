<div>
    @if($research)
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">

                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 border-right offset-md-0">
                            <livewire:components.research.information :researchId="$research->id" :wire:key="'information-'.$research->id">
                            <hr>
                            <b>Reviewer(s) of Student's Proposal</b>
                            <br>
                            @if($research->history->contains('type_id',\App\Models\ArSys\ResearchLogType
                                ::where('code', 'REV')->first()->id))

                                @if(!is_null($research->proposalReview))
                                    @foreach($research->proposalReview as $index => $review)
                                        @if($review->staff != null)
                                            {{$index+1}}. {{$review->staff->first_name}} {{$review->staff->last_name}}
                                            <br>
                                        @endif
                                    @endforeach
                                @endif
                            @else
                                The research topic was activated without review
                            @endif
                            <hr>
                            @php($counter = 0)
                            @if($research->supervisor->isNotEmpty())
                                <b>Supervisor of Student's Research</b>
                                <br>
                                @foreach($research->supervisor as $index => $supervisor)
                                    @if(!is_null($supervisor->staff))
                                        @php($counter++)
                                        {{$counter}}. {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                        <br>
                                    @endif
                                @endforeach
                            @endif
                            @if($research->supervisordummy->isEmpty())
                                <x-adminlte-button  class="btn-xs" theme="info" wire:click="$emit('supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd',{{$researchId}})" icon="fa fa-user-plus" label="Add supervisor"/>
                            @else
                                @foreach($research->supervisordummy as $index => $supervisor)
                                    @php($counter++)
                                    @if(!is_null($supervisor->staff))
                                        {{$counter}}. {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                        <br>
                                    @endif
                                    <x-adminlte-button  class="btn-xs" theme="success" wire:click="proceedAddSupervisor({{$research->id}})" icon="fa fa-user-plus" label="Proceed"/>
                                    <x-adminlte-button  class="btn-xs" theme="danger" wire:click="cancelAddSupervisor({{$research->id}})" icon="fa fa-user-minus" label="Cancel"/>
                                @endforeach
                            @endif
                        </div>
                        <div class="col-md-6 offset-md-0">
                            <livewire:components.research.approval :researchId="$research->id" :wire:key="'approval-'.$research->id">
                            <livewire:components.research.applied-event  :researchId="$research->id" :wire:key="'applied-event-'.$research->id">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    @endif
    <livewire:specialization.research.components.modal.supervisor-add>
    <livewire:specialization.research.components.modal.supervisor-external-add>
</div>
