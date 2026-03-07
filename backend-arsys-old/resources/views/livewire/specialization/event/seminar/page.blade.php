<div>
    {{--
    <div class="row">
        <div class="col-md-4">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search the date of event">
        </div>
    </div>
    --}}
    <div class="row">
        <div class="col-md-12">
            @if($events->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="2%">No</th>
                                <th width="15%">Id</th>
                                <th width="10%">Host</th>
                                <th width="40%">Date of event</th>
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
                                <th class="text-right" width="15%">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($events as $index => $event)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td><b><span style="color:red;">{{$index+1}}.</span></b></td>
                                    <td>
                                        {{$event->type->code.'-'.(\Carbon\Carbon::parse($event->event_date)->format('dmY'))}}
                                        -{{$event->id}}
                                    </td>
                                    <td>
                                        {{$event->program->code}}-{{$event->program->abbrev}}
                                    </td>

                                    <td>
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                                        &nbsp;|&nbsp;
                                        <span wire:click="$emit('edit_ArSysSpecializationEventApplicant', {{$event->id}})" style="cursor: pointer;color:green">
                                            <i style="" class="fas fa-xs fa-edit" ></i>
                                            <u>edit</u>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="text-center">
                                            {{$event->quota}}
                                        </div>

                                    </td>
                                    <td>
                                        <div class="text-center">
                                            @if(!is_null($event->finaldefenseApplicant))
                                                {{$event->finaldefenseApplicant->count()}}
                                            @endif
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$event->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @else

                                        @if($event->finaldefenseApplicantPublish)
                                           <livewire:specialization.event.seminar.schedule :eventId="$event->id" :wire:key="'schedule-'.$event->id">
                                        @endif

                                            <x-adminlte-button   wire:click="publishEvent({{$event->id}})"
                                                theme="warning" icon="fa fa-xs fa-eye" class="btn btn-outline btn-xs" label="Publish"/>
                                        @endif
                                    </td>
                                    <td></td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td colspan="7">
                                            <div x-data="{viewEvent : @entangle('viewEvent') }">
                                                <div x-show="viewEvent">
                                                    <livewire:specialization.event.seminar.view :eventId="$event->id" :wire:key="'view-'.$event->id">
                                                </div>
                                            </div>
                                        </td>
                                        <td width="1%"></td>
                                    </tr>
                                @endif
                        @endforeach
                        </tbody>
                    </table>
                </div>
                {{$events->render()}}
            @else
                <i style="color: red">
                    There is no event with applicant
                </i>
            @endif
        </div>
    </div>
    <livewire:specialization.event.components.event-date-edit>
    <x-flatpickr::script />
</div>
