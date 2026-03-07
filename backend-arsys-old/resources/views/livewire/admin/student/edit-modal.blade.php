<div>
    <!-- Modal -->
   
    <div class="modal fade" id="editStudentModal_AdminUserStudent" tabindex="1" role="dialog" aria-labelledby="editStudentModal_AdminUserStudent" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editStudentModal_AdminUserStudent">Edit student's profile</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label for="researchFile">Research Type</label>
                                <br>
                                <select class="select2" id='studentProgramEdit' style='width: 100%;'>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
        
                    <hr>
        
                    <div class="row">
                        <div class="col-md-12 text-left">
                            <x-adminlte-button   wire:click="updateProfile" theme="success" icon="fa fa-save" class="btn btn-sm" label="Save"/>
                        </div>
                    </div>
                </div>   
            </div>
        </div>
    </div>
    @push('scripts')
        <script>
            window.livewire.on('editStudentModal_AdminUserStudent_Show', () => {
                $('#editStudentModal_AdminUserStudent').modal('show');
                console.log('show modal');
            });

            $(document).ready(function(){
            $( "#researchType" ).select2();

            $( "#researchType" ).on('change', function(e) {
            // Access to full data
                console.log($(this).select2('data'));
                var data = $('#researchType').select2("val");
                window.livewire.emit('selectResearchType', { researchType : data });

            });
        });
            
        </script>
    @endpush
</div>
