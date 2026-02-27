@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Program's admin</b> | Home
                </div>
                <div class="card-body">
                    <livewire:admin.page :wire:key="'arsys.admin.page'"/>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
