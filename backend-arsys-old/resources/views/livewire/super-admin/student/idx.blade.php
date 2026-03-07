@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <b>Super admin</b> | Student management
                </div>
                <div class="card-body">
                    <livewire:super-admin.student.page :wire:key="'livewire:admin.student.page'"/>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
