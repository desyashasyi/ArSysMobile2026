<div>
    <div class="row">
        <div class="col-md-12 offset-sm-0">
           <div class="card card-outline card-success">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 border-right offset-md-0">
                            <livewire:specialization.research.components.reviewer :researchId="$research->id" :wire:key="'re-new.view-'.$research->id">
                        </div>
                        <div class="col-md-6 offset-md-0">
                            <livewire:specialization.research.components.supervisor :researchId="$research->id" :wire:key="'re-new.view-'.$research->id">
                        </div>
                    </div>
                </div>
           </div>
        </div>
    </div>
</div>
