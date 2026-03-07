@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Event</b> | List of Event
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">

                        </div>
                    </div>
                    {{--
                    <livewire:components.select-research-type :programId="$programId">
                    --}}
                    <livewire:specialization.event.page>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
