<div>
    <div wire:ignore.self class="modal fade" id="editEventModal"  role="dialog" aria-labelledby="editEventModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-sm" role="document">
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
                            <div class="col-md-12">
                                <label for="dateOfEventEdit"><b>Date of Event</b></label>
                                <x-flatpickr :disableMobile="true" wire:model="dateOfEventEdit" id="dateOfEventEdit" :time24hr="true" name="dateOfEventEdit" show-time alt-format="F j, Y | H:i"/>
                                @error('dateOfEventEdit') <i class="text-danger">{{ $message }}</i>@enderror
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <div class="col-md-12">
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
                window.livewire.on('editEventDate_ArSysSpecializationEvenApplicant', () => {
                    $('#editEventModal').modal('show');
                    const eventDate = flatpickr('#dateOfEventEdit', {
                        allowInput: true,
                    });
                }); 
            });
           
        </script>
    @endpush
</div>

