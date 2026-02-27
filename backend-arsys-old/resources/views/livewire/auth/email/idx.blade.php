@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12 text-left">
            <livewire:auth.email.page :userCode="$userCode">
        </div>
    </div>
</div>
@endsection