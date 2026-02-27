@section('content')
@section('plugins.Select2', true)
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Config</b> | Research config
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12">
                            <livewire:admin.config.research.page>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
