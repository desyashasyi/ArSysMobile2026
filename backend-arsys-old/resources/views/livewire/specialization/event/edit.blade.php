<div>
    <div wire:ignore.self class="modal fade" id="editEventModal"  role="dialog" aria-labelledby="editEventModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editEventModal">Edit Event</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="card-body">
                        <div class="row" >
                            <div class="col-md-6">
                                <label for="dateOfEventEdit"><b>Date of Event</b></label>
                                <x-flatpickr :disableMobile="true" wire:model="dateOfEventEdit" id="dateOfEventEdit" :time24hr="true" name="dateOfEventEdit" show-time alt-format="F j, Y | H:i"/>
                                @error('dateOfEventEdit') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                            <div class="col-md-6">
                                <label for="applicationDeadlineEdit"><b>Application Deadline</b></label>
                                <x-flatpickr :disableMobile="true" wire:model="applicationDeadlineEdit" id="applicationDeadlineEdit" :time24hr="true" name="applicationDeadlineEdit" show-time alt-format="F j, Y | H:i"/>
                                @error('applicationDeadlineEdit') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                        </div>
                        <br>
                        <div class="row" >
                            <div class="col-md-6">
                                <label for="draftDeadlineEdit"><b>Draft Deadline</b></label>
                                <x-flatpickr :disableMobile="true" wire:model="draftDeadlineEdit" id="draftDeadlineEdit" :time24hr="true" name="draftDeadlineEdit" show-time alt-format="F j, Y | H:i"/>
                                @error('draftDeadlineEdit') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                            <div class="col-md-3">
                                <label for="quota"><b>Quota</b></label>
                                <input type="text" class="form-control" id="quota" wire:model="quota">
                                @error('quota') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <div class="col-md-4">
                                <x-adminlte-button wire:click="update" icon="fa fa-save" class="btn btn-sm" name="quota" theme="success" label="Update" i/>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                </div>
           </div>
        </div>
       
    </div>
    @push('scripts')
        <script>
            var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function() {
                window.livewire.on('editEventModal_ArSysSpecializationEventPage', () => {
                    $('#editEventModal').modal('show');
                    const eventDate = flatpickr('#dateOfEventEdit', {
                        allowInput: true,
                    });
                    const applicationDeadline = flatpickr('#applicationDeadlineEdit', {
                        allowInput: true,
                    });
                    const draftDeadline = flatpickr('#draftDeadlineEdit', {
                        allowInput: true,
                    });
                }); 
            });
           
        </script>
    @endpush
</div>

