<div>
    <script src="/js/pickaday.js"></script>
    @if($research)
        <div class="row">
            <div class="col-md-12 offset-sm-0">
            <div class="card">
                    <div class="card-header bg-info">
                    </div>
                    <div class="text-right card-body" >
                        <div class="text-right row">
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-input class="text-right" wire:model="facultyNumber" placeholder="Nomor surat ST Fakultas" name="facultyLetter" 
                                label="Nomor surat fakultas" style="width: 100%"/>
                                <i>{{\App\Models\ArSys\FacultyLetter::where('faculty_id', $research->student->program->faculty->id)
                                    ->where('faculty_letter_base_id',\App\Models\ArSys\FacultyLetterBase::where('code', 'SPV-TA')->first()->id)->first()->number}}</i>
                                    <br>
                                @error('facultyNumber') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-input class="text-right" wire:model="facultyLetterDate" placeholder="Tanggal ST Fakultas" name="facultyLetterDate" label="Tanggal surat fakultas" style="width: 100%"/>
                                @error('facultyLetterDate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                
                            </div>
                        </div>
                        <hr>
                        <div class="text-right row">
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-input class="text-right" wire:model="programNumber" placeholder="Nomor surat prodi" name="programLetter" 
                                label="Nomor surat prodi" style="width: 100%"/>
                                <i>
                                    {{\App\Models\ArSys\ProgramLetter::where('program_id', $research->student->program->id)
                                ->where('program_letter_base_id',\App\Models\ArSys\ProgramLetterBase::where('code', 'SPV-TA')->first()->id)->first()->number}}
                                </i>
                                <br>
                                @error('programNumber') <span class="text-danger">{{ $message }}</span><br> @enderror
                                
                            </div>
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-input class="text-right" wire:model="programLetterDate" placeholder="Tanggal surat prodi" name="programLetterDate" label="Tanggal surat prodi" style="width: 100%"/>
                                @error('programLetterDate') <span class="text-danger">{{ $message }}</span><br> @enderror
                                
                            </div>
                        </div>
                        <hr>
                        <div class="text-right row">
                            <div class="text-right col-md-6 offset-md-0">
                            </div>
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-input class="text-right" wire:model="expireDate" placeholder="Tanggal akhir berlaku" name="expiredDate" label="Tanggal akhir berlaku" style="width: 100%"/>
                                @error('expireDate') <span class="text-danger">{{ $message }}</span><br> @enderror
                            </div>
                        </div>
                        
                        <div class="text-right row">
                            <div class="text-right col-md-6 offset-md-0">
                            
                            </div>
                            <div class="text-right col-md-6 offset-md-0">
                                <x-adminlte-button   wire:click="saveLetter({{$researchId}})" 
                                theme="success" icon="fa fa-sm fa-save" class="btn btn-sm" label="Simpan surat"/>
                                @if($research->spvLetter)
                                    <x-adminlte-button   wire:click="printAssignment({{$researchId}})" 
                                        theme="success" icon="fa fa-sm fa-print" class="btn btn-sm" label="Lanjutkan cetak"/>
                                @endif
                            </div>
                        </div>
                    </div>    
            </div>
            </div>            
        </div>
    @endif
    <script>
        //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
        $(document).ready(function () {
            window.livewire.on('reloadPickadayLetterDate',()=>{
                console.log('here');
                $('#letterDate').pikaday();
            });

        });
    </script>
</div>