<div>
    <div wire:ignore.self class="modal fade" id="editResearchSTudentEditModal" tabindex="-1" role="dialog"
        aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editResearchSTudentEditModal">Edit Research</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body" style="width: 100%; height: 520px; overflow-y: scroll; overflow-x: hidden">
                    {{--
                    <div class="row">
                        <div class="col-md-6">
                            <x-adminlte-select2 label="Program of study" style="width: 100%"
                                wire:model="researchTypeEdit" id="researchTypeEdit" name="researchTypeEdit">
                                <option default>Please select research type</option>
                                @foreach ($researchTypes as $index => $type)
                                    <option value="{{ $type->id }}">{{ $index + 1 }}.
                                        <b>{{ $type->data->code }}</b>-{{ $type->data->description }}</option>
                                @endforeach
                            </x-adminlte-select2>
                            @error('programCreate')
                                <span class="text-danger">{{ $message }}</span><br>
                            @enderror
                        </div>
                    </div>
                    --}}

                    <div class="row">
                        <div class="col-md-12">
                            @if(!is_null($researchId))
                            @endif
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <i style="color:red">
                                For now, the research type could not be edited. if you have already entered the wrong type, please delete your proposal and then create the new one.
                            </i>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-md-12">
                            {{-- With prepend slot, sm size and label --}}
                            <x-adminlte-textarea wire:model="title" name="title" label="Title" rows=2
                                igroup-size="sm" placeholder="Insert research title...">
                            </x-adminlte-textarea>
                            @error('title')
                                <span class="text-danger">{{ $message }}</span><br>
                            @enderror
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            {{-- With prepend slot, sm size and label --}}
                            <x-adminlte-textarea wire:model="abstract" name="abstract" label="Abstract" rows=5
                                igroup-size="sm" placeholder="Insert abstract...">
                            </x-adminlte-textarea>
                            @error('abstract')
                                <span class="text-danger">{{ $message }}</span><br>
                            @enderror
                        </div>
                    </div>
                    @if (\App\Models\ArSys\ResearchConfig::where('program_id', Auth::user()->student->program_id)->where('config_base_id', \App\Models\ArSys\ResearchConfigBase::where('code', 'RESEARCH_FILE')->first()->id)->first()->status == 1)
                        <div class="row">
                            <div class="col-md-12">
                                <x-adminlte-input-file wire:model="file" name="ifLabel" label="Proposal file"
                                    placeholder="Choose a file..." />
                                <br>
                                @error('file')
                                    <span class="text-danger">{{ $message }}</span> <br>
                                @enderror
                                <div wire:loading wire:target="file">Uploading...</div>
                            </div>
                        </div>
                    @else
                        <div class="row">
                            <div class="col-md-12">
                                <label for="proposalUrl">Proposal URL</label>
                                <input type="text" class="form-control" wire:model="proposalUrl" id="proposalUrl"
                                    placeholder="Enter document url">
                                @error('proposalUrl')
                                    <span class="text-danger">{{ $message }}</span>
                                @enderror
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                1. Upload file of your proposal to Google Drive, and make sure the file is accesible
                                <br>
                                2. Attach the url of your proposal in the form
                                <br>
                                <i style="color:red">
                                    <b>Note: Unaccesible file will cause your proposal could not be processed</b>
                                </i>
                            </div>
                        </div>
                    @endif
                    <div class="row justify-content-right">
                        <div class="text-right col-md-12">
                            <x-adminlte-button wire:click="update" theme="success" label="Update" class="btn-sm"
                                icon="fas fa-microscope" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
        <script>
            window.livewire.on('editResearchModal_ArSysStudentResearchEdit', () => {
                $('#editResearchSTudentEditModal').modal('show');
            });
            window.livewire.on('editResearchModal_Hide_ArSysStudentResearchEdit', () => {
                $('#editResearchSTudentEditModal').modal('hide');
            });
        </script>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function() {
                $('#researchTypeEdit').on('change', function(e) {
                    let dataProgram = $(this).val();
                    @this.set('researchTypeEdit', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectResearchTypeEdit', () => {
                    $('#researchTypeEdit').select2('destroy');
                    $('#researchTypeEdit').select2();
                });
            });
        </script>
    @endpush

</div>
