<div>
    <div wire:ignore.self class="modal fade" id="studentEventApplyModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="studentEventApplyModal">Apply Event</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($research != null)
                        <div class="row">
                            <div class="col-sm-3">
                                <b>Research ID</b>
                            </div>
                            <div class="col-sm-9">
                                {{$research->code}}
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <b>Title</b>
                            </div>
                            <div class="col-sm-9">
                                {!!$research->title!!}
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <b>Supervisor</b>
                            </div>
                            <div class="col-sm-9">
                                @php($counter = 0)
                                @foreach($research->supervisor as $supervisor)
                                    @php(++$counter)
                                    {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                    @if($counter != count($research->supervisor))
                                        |
                                    @endif
                                @endforeach
                            </div>
                        </div>
                    @endif
                    @if(!is_null($events))
                        <div class="table-responsive users-table">
                            <table class="table table-sm data-table">
                                <thead class="thead">
                                    <tr>
                                        <th width="5%">No</th>
                                        <th width="15%">Id</th>
                                        <th width="10%">Host</th>
                                        <th width="50%">Date of event</th>
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
                                            @if($event->type->code == "PUB")
                                                @if(!is_null($event->finaldefenseApplicant))
                                                    {{$event->finaldefenseApplicant->count()}}
                                                @endif
                                            @endif
                                            @if($event->type->code == "PRE")
                                                @if(!is_null($event->defenseApplicant))
                                                    {{$event->defenseApplicant->count()}}
                                                @endif
                                            @endif

                                            @if($event->type->code == "SSP")
                                                @if(!is_null($event->seminarApplicant))
                                                    {{$event->seminarApplicant->count()}}
                                                @endif
                                            @endif
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        @if($event->type->code == "PUB")
                                            @if(!$event->finaldefenseApplicant->contains('research_id', $research->id))
                                                <x-adminlte-button wire:click="apply({{$event->id}})" theme="success" label="Apply" class="btn-xs" icon="fas fa-upload"/>
                                            @else
                                                <x-adminlte-button theme="default" label="Applied" class="btn-xs" icon="fas fa-upload" disabled/>
                                            @endif
                                        @elseif($event->type->code == "PRE")
                                            @if(!$event->defenseApplicant->contains('research_id', $research->id))
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
                    @else
                        <hr>
                        There is no event that could be applied.
                    @endif
                </div>
                <div class="modal-footer">
                </div>
    
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('studentEventApplyModal', () => {
            $('#studentEventApplyModal').modal('show');
        });
    </script>
</div>
