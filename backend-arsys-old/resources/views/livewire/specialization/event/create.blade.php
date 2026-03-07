<div>
    <div x-data="{ addEvent: @entangle('addEvent') }">
        @if (!$addEvent)
            <div class="row">
                <div class="text-right col-md-12">
                    <x-adminlte-button wire:click="addEvent" theme="success"
                        icon="fa fa-plus-circle" class="btn btn-sm" label="Add event" />
                </div>
            </div>
        @endif
        <div x-show="addEvent">
            <div class="text-left">
                <div class="text-left card">
                    <div class="card-header bg-warning">
                        <div class="row">
                            <div class="text-left col-md-6">
                                <b>Create new event</b>
                            </div>
                            <div class="text-right col-md-6">
                                <i class="fa fa-times-circle" wire:click="addEvent"
                                    style="color: red; cursor:pointer"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-5">
                                <x-adminlte-select2 label="Type of Event" style="width: 100%" wire:model="eventTypeCreate"
                                    id="eventType" name="eventType">
                                    <option default>Please select research type</option>
                                    @foreach ($eventTypes as $index => $type)
                                        <option value="{{ $type->id }}">{{ $index + 1 }}.
                                            <b>{{ $type->code }}</b>-{{ $type->description }}</option>
                                    @endforeach
                                </x-adminlte-select2>
                                @error('eventTypeCreate')
                                    <span class="text-danger">{{ $message }}</span><br>
                                @enderror
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label for="dateOfEvent"><b>Date of Event</b></label>
                                <x-flatpickr wire:model="dateOfEvent" id="dateOfEvent" name="dateOfEvent" :time24hr="true" show-time alt-format="F j, Y | H:i"/>
                                @error('dateOfEvent') <i class="text-danger"><h6>{{ $message }}</i>@enderror
                                
                            </div>
                            <div class="col-md-5">
                                <label for="applicationDeadline"><b>Application Deadline</b></label>
                                <x-flatpickr wire:model="applicationDeadline" id="applicationDeadline" :time24hr="false" name="draftDeadlineapplicationDeadline" show-time alt-format="F j, Y | H:i"/>
                                @error('applicationDeadline') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                           
                        </div>
                        <br>
                        <div class="row">
                            <div class="col-md-5">
                                <label for="draftDeadline"><b>Draft Deadline</b></label>
                                <x-flatpickr wire:model="draftDeadline" id="draftDeadline" name="draftDeadline" :time24hr="false" show-time alt-format="F j, Y | H:i"/>
                                @error('draftDeadline') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                            <div class="col-md-3">
                                <div class="row">
                                    <x-adminlte-input name="quota" id="quota" wire:model="quota" label="Quota" placeholder="Enter quota"
                                        fgroup-class="col-md-12"/>
                                </div>
                                
                                @error('quota') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-4">
                                <x-adminlte-button wire:click="save" icon="fa fa-save" class="btn btn-sm" name="quota" theme="success" label="Save" i/>
                            </div>
                        </div>
                       
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
       
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function() {
                $('#eventType').on('change', function(e) {
                    let dataProgram = $(this).val();
                    @this.set('eventTypeCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectEventType', () => {
                    $('#eventType').select2('destroy');
                    $('#eventType').select2();
                });
            });
            
        </script>
    @endpush
    
</div>
