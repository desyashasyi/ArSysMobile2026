@section('content')

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-12">
            <div class="card card-outline card-primary">
                <div class="card-header">
                    <b>Profile</b> | Edit of user profile
                </div>
                <div class="card-body">
                    @if(strlen(\App\Models\User::where('id', Auth::user()->id)->first()->sso) > 7)
                        <livewire:arsys.user.profile.edit.staffs/)
                    @else
                        <livewire:user.profile.edit.students/>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
