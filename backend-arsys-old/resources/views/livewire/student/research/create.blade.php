<div>
    <div x-data="{ addResearch: @entangle('addResearch') }">
        @if (!$addResearch)
            <div class="row">
                <div class="text-right col-md-12">
                    <x-adminlte-button wire:click="addResearch" theme="success"
                        icon="fa fa-plus-circle" class="btn btn-sm" label="Add research" />
                </div>
            </div>
        @endif
            {{--
            <div x-show="addResearch">
                <livewire:student.research.create :wire:key="'arsys.student.research.create'">
            </div>
            </div>
            <div x-data="{ addResearch: @entangle('addResearch') }">
                @if (!$addResearch)
                    <div class="row">
                        <div class="text-right col-md-12">
                        <x-adminlte-button wire:click="addResearch" theme="success"
                            icon="fa fa-plus-circle" class="btn btn-sm" label="Add research" />
                    </div>
                </div>
            @endif
            --}}
        <div x-show="addResearch">
            <div class="text-left" wire:key="arsys.student.research.create">
                <div class="text-left card">
                    <div class="card-header bg-warning">
                        <div class="row">
                            <div class="text-left col-md-6">
                                <b>Create new research proposal</b>
                            </div>
                            <div class="text-right col-md-6">
                                <i class="fa fa-times-circle" wire:click="addResearch")"
                                    style="color: red; cursor:pointer"></i>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-5">
                                <x-adminlte-select2 label="Research type" style="width: 100%" wire:model="researchTypeCreate"
                                    id="researchTypeCreate" name="researchTypeCreate">
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
                        <div class="row">
                            <div class="col-md-12">
                                1. Select SK-Skripsi/TA if you will complete your study by research of bachelor thesis
                                <br>
                                2. Select RP-Rekognisi Publikasi if you have an article published in national journal indexing
                                (>= SINTA3),
                                <br>
                                3. Select RP-Rekognisi Kejuaraan if you have achievement such as winner of the following event: Pekan Kreativitas Mahasiswa, Gemastik, etc.
                                <br>
                                4. Select SP-Seminar Program Studi if your research is TA-like product.
                                <br>
                                <i style="color:red">
                                    <b>Note: Don't make inappropriate selection if you don't want to hamper the research process
                                    </b>
                                    <br>
                                    For now, the research type could not be edited. Hence, please submit approviate research type.
                                </i>
                            </div>
                        </div>
                        <br>
                        <div class="row">
                            <div class="col-md-12">
                                {{-- With prepend slot, sm size and label --}}
                                <x-adminlte-textarea wire:model="title" name="title" label="Title" rows=2 igroup-size="sm"
                                    placeholder="Insert research title...">
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
                                <x-adminlte-button wire:click="save" theme="success" label="Save" class="btn-sm"
                                    icon="fas fa-microscope" />
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
                $('#researchTypeCreate').on('change', function(e) {
                    let dataProgram = $(this).val();
                    @this.set('researchTypeCreate', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectResearchTypeCreate', () => {
                    $('#researchTypeCreate').select2('destroy');
                    $('#researchTypeCreate').select2();
                });
            });
        </script>
    @endpush
</div>
