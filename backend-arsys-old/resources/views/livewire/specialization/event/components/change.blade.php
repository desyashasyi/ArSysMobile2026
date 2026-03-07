<div>
    <div wire:ignore.self class="modal fade" id="specializationEventChangeModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="specializationEventChangeModal">Change Event</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($events->isNotEmpty())
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
                                                    @if($eventTypeId == \App\Models\ArSys\EventType::where('code', 'PRE')->first()->id)
                                                        {{$event->defenseApplicant->count()}}
                                                    @elseif($eventTypeId == \App\Models\ArSys\EventType::where('code', 'PUB')->first()->id)
                                                        {{$event->finaldefenseApplicant->count()}}
                                                    @else
                                                        {{$event->seminarApplicant->count()}}
                                                    @endif
                                                </div>
                                            </td>
                                            <td class="text-right">
                                                @if($eventTypeId == \App\Models\ArSys\EventType::where('code', 'PRE')->first()->id)
                                                    @if(!$event->defenseApplicant->contains('research_id', $research->id))
                                                        <x-adminlte-button wire:click="apply({{$event->id}})" theme="success" label="Apply" class="btn-xs" icon="fas fa-upload"/>
                                                    @else
                                                        <x-adminlte-button theme="default" label="Applied" class="btn-xs" icon="fas fa-upload" disabled/>
                                                    @endif
                                                @elseif($eventTypeId == \App\Models\ArSys\EventType::where('code', 'PUB')->first()->id)
                                                    @if(!$event->finaldefenseApplicant->contains('research_id', $research->id))
                                                        <x-adminlte-button wire:click="apply({{$event->id}})" theme="success" label="Apply" class="btn-xs" icon="fas fa-upload"/>
                                                    @else
                                                        <x-adminlte-button theme="default" label="Applied" class="btn-xs" icon="fas fa-upload" disabled/>
                                                    @endif
                                                @else
                                                    @if(!$event->seminarApplicant->contains('research_id', $research->id))
                                                        <x-adminlte-button wire:click="apply({{$event->id}})" theme="success" label="Apply" class="btn-xs" icon="fas fa-upload"/>
                                                    @else
                                                        <x-adminlte-button theme="default" label="Applied" class="btn-xs" icon="fas fa-upload" disabled/>
                                                    @endif
                                                @endif
                                            </td>
                                        </tr>    
                                        
                                @endforeach
                                </tbody>
                            </table>
                        </div>
                    {{$events->render()}}
                    @endif
                </div>
                <div class="modal-footer">
                </div>
    
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('change_SpecializationEventChangeModal', () => {
            $('#specializationEventChangeModal').modal('show');
        });
    </script>
</div>
