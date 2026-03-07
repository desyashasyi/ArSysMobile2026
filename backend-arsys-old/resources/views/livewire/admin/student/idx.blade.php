@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>User Management</b> | Student
                </div>
                <div class="card-body">
                    <livewire:admin.student.page :wire:key="'livewire:admin.student.page'"/>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
