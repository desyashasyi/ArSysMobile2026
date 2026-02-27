@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Students' research</b> | New and Renewal submission
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">

                        </div>
                    </div>
                    {{--
                    <livewire:components.select-research-type :programId="$programId">
                    --}}
                    <livewire:specialization.research.new-proposal.page :wire:key="'arsys.specialization.research.new.page'">
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
