@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Students' research</b> | Being reviewed
                </div>
                <div class="card-body">
                    <livewire:specialization.research.being-reviewed.page :wire:key="'arsys.specialization.research.being-reviewed.page'">
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
