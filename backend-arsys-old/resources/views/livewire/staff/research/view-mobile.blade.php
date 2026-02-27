<div>
    <div class="row d-block d-sm-none">
        <div class="col-sm-12 offset-sm-0">
            @if($research)
                <div class="card">
                    <div class="card-header bg-warning">
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-12 offset-sm-0">
                                <livewire:staff.research.components.supervise :wire:key="'$research->id'">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 offset-sm-0">
                                <livewire:staff.research.components.approval :wire:key="'$research->id'">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 offset-sm-0">
                                {{--<livewire:staff.research.components.event :wire:key="'$research->id'">--}}
                            </div>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
