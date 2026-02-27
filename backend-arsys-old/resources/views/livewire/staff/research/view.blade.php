<div>
    @if($research)
        <div class="row">
            <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8 border-right offset-md-0">
                                <livewire:components.research.information :researchId="$research->id" :wire:key="'information-'.$research->id">
                                <livewire:components.research.supervise :researchId="$research->id" :wire:key="'supervise-'.$research->id">
                            </div>
                            <div class="col-md-4 offset-md-0">
                                <livewire:components.research.approval :researchId="$research->id" :wire:key="'approval-'.$research->id">
                                <livewire:components.research.applied-event  :researchId="$research->id" :wire:key="'applied-event-'.$research->id">
                            </div>
                        </div>
                    </div>
            </div>
            </div>
        </div>
    @endif
</div>
