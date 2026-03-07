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
                                <th class="text-right" width="17%">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($events as $index => $event)
                                @if($event->status == 1)
                                    @if($index%2 == 0)
                                        <tr class="bg-light">
                                    @else
                                        <tr>
                                    @endif
                                        <td><b><span style="color:red;">{{$index+1}}.</span></b></td>
                                        <td>
                                            {{$event->type->code.'-'.(\Carbon\Carbon::parse($event->event_date)->format('dmY'));}}
                                        </td>
                                        <td>{{$event->type->description}}</td>

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
                                                {{$event->finaldefenseApplicant->count()}}
                                            </div>
                                        </td>
                                        <td class="text-right">
                                            @if(!$expandViewIndex[$index])
                                                <x-adminlte-button   wire:click="expandView({{$index}}, {{$event->id}})"
                                                    theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                            @else
                                            <x-adminlte-button   wire:click="exportMark({{$event->id}})"
                                                theme="success" icon="fa fa-xs fa-file-excel" class="btn btn-xs" label="Excel"/>
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
                                                        <livewire:program.research.final-defense.view :eventId="$event->id" :wire:key="'view-'.$event->id">
                                                    </div>
                                                </div>

                                            </td>
                                            <td width="1%"></td>
                                        </tr>
                                    @endif
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
