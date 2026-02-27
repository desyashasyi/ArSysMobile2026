<div>
    <div class="row d-none d-md-block">
        <div class="col-sm-12 offset-sm-0">
            @if(!is_null($research))
                <div class="card card-outline card-success">
                    <div class="card-body">
                        <div class="row">
                            <div class="text-right col-md-12 offset-sm-0">
                                <x-adminlte-button class="btn-sm" theme="success"  wire:click="accept" icon="fa fa-check-circle" aria-hidden="true" label="Approve"/>
                                <x-adminlte-button class="btn-sm" theme="danger"  wire:click="reject" icon="fa fa-ban" aria-hidden="true" label="Reject"/>
                            </div>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
    @include('livewire.staff.review.view-mobile')
</div>
