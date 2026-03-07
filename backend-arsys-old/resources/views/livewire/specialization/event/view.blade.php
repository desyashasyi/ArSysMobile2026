<div>
    @if($event)
        <div class="row">
            <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <x-adminlte-input label="Application Deadline" 
                                    value="
                                    {{ \Carbon\Carbon::parse($event->application_deadline)->format('l,') }} {{ \Carbon\Carbon::parse($event->application_deadline)->format('d F Y') }} | {{ \Carbon\Carbon::parse($event->application_deadline)->format('H:i') }}
                                    " 
                                    id="dateOfEvent" name="dateOfEvent" disabled/>
                                
                            </div>
                            <div class="col-md-6">

                                <x-adminlte-input label="Draft Deadline"
                                    value="
                                    {{ \Carbon\Carbon::parse($event->draft_deadline)->format('l,') }} {{ \Carbon\Carbon::parse($event->draft_deadline)->format('d F Y') }} | {{ \Carbon\Carbon::parse($event->draft_deadline)->format('H:i') }}
                                    "
                                    id="draftDeadlineapplicationDeadline" name="draftDeadlineapplicationDeadline" disabled/>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 text-right">
                                @if(Auth::user()->hasRole('defense'))
                                    <x-adminlte-button wire:click="$emit('editEvent_ArSysSpecializationEventPage', {{$eventId}})" theme="warning"
                                    icon="fa fa-edit" class="btn btn-sm" label="Edit" />
                                    
                                @endif
                            </div>
                        </div>    
                        
                    </div>    
            </div>
            </div>            
        </div>
    @endif
</div>