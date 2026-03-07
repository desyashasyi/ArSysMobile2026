@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <b>Super Admin</b> | Configuration of program study
                </div>
                <div class="card-body">
                    <livewire:super-admin.config.program.page :wire:key="'arsys.super-admin.config.program.page'">
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
