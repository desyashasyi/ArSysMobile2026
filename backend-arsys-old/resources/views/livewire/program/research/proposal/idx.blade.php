@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Program</b> | Students' research approval (SIAS Proposal)
                </div>
                <div class="card-body">
                    <livewire:program.research.proposal.page :wire:key="'arsys.program.research.proposal.page'">
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
