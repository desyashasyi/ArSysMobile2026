<div>
    @if(Auth::user()->hasRole('defense'))
        <livewire:specialization.event.create>
        <hr>
    @endif
    <div class="row">
        <div class="col-md-5">
            <x-adminlte-select2 label="Type of Event" style="width: 100%" wire:model="eventTypePage"
                id="eventTypePage" name="eventTypePage">
                <option default>Please select event type</option>
                @foreach ($eventTypes as $index => $type)
                    <option value="{{ $type->id }}">{{ $index + 1 }}.
                        <b>{{ $type->code }}</b>-{{ $type->description }}</option>
                @endforeach
            </x-adminlte-select2>
        </div>
    </div>


    <div class="row">
        <div class="col-md-12">
            @if($events->isNotEmpty())
                {{--
                <div class="row">
                    <div class="col-md-4">
                        <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search the date of event">
                    </div>
                </div>
                --}}
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="15%">Id</th>
                                <th width="15%">Description</th>
                                <th width="10%">Host</th>
                                <th width="35%">Date of event</th>
                                <th width="5%">
                                    <div class="text-center">
                                        Quota
                                    </div>
                                </th>
                                <th width="5%">
                                    <div class="text-center">
                                        Applicant
                                    </div>
                                </th>
                                <th class="text-right" width="10%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($events as $index => $event)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$event->type->code.'-'.(\Carbon\Carbon::parse($event->event_date)->format('dmY'));}}
                                    </td>
                                    <td>{{$event->type->description}}</td>
                                    <td>
                                        {{$event->program->code}}-{{$event->program->abbrev}}
                                    </td>

                                    <td>
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                                    </td>
                                    <td>
                                        <div class="text-center">
                                            {{$event->quota}}
                                        </div>

                                    </td>
                                    <td>
                                        <div class="text-center">
                                            @if($event->defenseApplicant->isNotEmpty())
                                                {{$event->defenseApplicant->count()}}
                                            @endif

                                            @if($event->finaldefenseApplicant->isNotEmpty())
                                                {{$event->finaldefenseApplicant->count()}}
                                            @endif
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$event->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif
                                        @if(Auth::user()->hasRole('defense'))
                                            @if($event->type->examination_type == 'Defense')
                                                @if($event->defenseApplicant->isEmpty())
                                                    <x-adminlte-button   wire:click="delete({{$event->id}})"
                                                        theme="danger" icon="fa fa-xs fa-trash" class="btn btn-xs" label="Delete"/>
                                                @endif
                                            @endif
                                            @if($event->type->examination_type == 'Seminar')
                                                @if($event->seminarApplicant->isEmpty())
                                                    <x-adminlte-button   wire:click="delete({{$event->id}})"
                                                        theme="danger" icon="fa fa-xs fa-trash" class="btn btn-xs" label="Delete"/>
                                                @endif
                                            @endif
                                        @endif
                                    </td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td colspan="2"></td>
                                        <td colspan="6">
                                            <div x-data="{viewEvent : @entangle('viewEvent') }">
                                                <div x-show="viewEvent">
                                                    <livewire:specialization.event.view :eventId="$event->id" :wire:key="'view-'.$event->id">
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                @endif
                        @endforeach
                        </tbody>
                    </table>
                </div>
                {{$events->render()}}
            @else
                <i style="color: red">
                    There is no data, please select the type of event!
                </i>
            @endif
        </div>
    </div>
    <livewire:specialization.event.edit>

    @push('scripts')

        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function() {
                $('#eventTypePage').on('change', function(e) {
                    let dataProgram = $(this).val();
                    @this.set('eventTypePage', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectEventTypePage', () => {
                    $('#eventTypePage').select2('destroy');
                    $('#eventTypePage').select2();
                });
            });
        </script>
    @endpush
    <x-flatpickr::script />
</div>
