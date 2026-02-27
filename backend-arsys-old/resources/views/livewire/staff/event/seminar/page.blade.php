<div>
    <div class="row">
        <div class="col-md-12">
            @if($events->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="2%">No</th>
                                <th width="15%">Id</th>
                                <th width="15%">Description</th>
                                <th width="35%">Date of event</th>
                                <th width="10%">Program</th>
                                <th class="text-right" width="12%">Action</th>
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
                                        {{$event->type->code.'-'.(\Carbon\Carbon::parse($event->event_date)->format('dmY'))}}-{{$event->id}}
                                    </td>
                                    <td>{{$event->type->description}}</td>

                                    <td>
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('l,') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('d F Y') }}
                                        {{ \Carbon\Carbon::parse($event->event_date)->format('H:i') }}
                                    </td>
                                    <td>
                                        {{$event->program->code}} {{$event->program->abbrev}}
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif

                                    </td>
                                    <td></td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td colspan="6">
                                            <div x-data="{viewEvent : @entangle('viewEvent') }">
                                                <div x-show="viewEvent">
                                                    <livewire:staff.event.final-defense.view :eventId="$event->id" :wire:key="'view-'.$event->id">
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
</div>
