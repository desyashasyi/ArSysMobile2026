<div>
    @section('content')

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-12">
                <div class="card card-outline card-primary">
                    <div class="card-header">
                        <b>Telegram</b> | User telegram setting
                    </div>
                    <div class="card-body">
                        @if(Auth::user())
                            @if(Illuminate\Support\Str::length(Auth::user()->sso) > 7)
                                @if(App\Models\ArSys\ResearchConfig::
                                    where('program_id', Auth::user()->staff->program_id)
                                    ->where('config_base_id',App\Models\ArSys\ResearchConfigBase::where('code', 'TELEGRAM_MESSAGE')->first()->id)
                                    ->first()->status == 1)
                                    <livewire:components.telegram.page>
                                @else
                                    Telegram notification is disable by admin of Study Program
                                @endif
                            @endif
                            @if((Illuminate\Support\Str::length(Auth::user()->sso) > 4) && (Illuminate\Support\Str::length(Auth::user()->sso) <= 7))
                                @if(App\Models\ArSys\ResearchConfig::
                                    where('program_id', Auth::user()->student->program_id)
                                    ->where('config_base_id',App\Models\ArSys\ResearchConfigBase::where('code', 'TELEGRAM_MESSAGE')->first()->id)
                                    ->first()->status == 1)
                                    <livewire:components.telegram.page>
                                @else
                                    Telegram notification is disable by admin of Study Program
                                @endif
                            @endif
                        @endif
                    </div>
                </div>
            </div>
        </div>
    </div>
    @endsection
    {{-- The whole world belongs to you. --}}
</div>
