<div>
    <div class="row">
        <div class="col-md-5">
            <x-adminlte-select2 label="Program of study" style="width: 100%" wire:model="programId" id="program" name="program">
                <option default>Please select your program of study</option>
                @foreach ($programs as $index => $program)
                    <option value="{{$program->id}}"><b>{{$program->code}}</b>-{{$program->name}}</option>
                @endforeach
                @error('program') <span class="text-danger">{{ $message }}</span><br> @enderror
            </x-adminlte-select2>
        </div>
    </div>
    <div class="row">
        <div class="text-left col-md-12">
            @if(!is_null($researchs))
                @if($researchs->isNotEmpty())
                    {{--
                    <div class="col-md-3 offset-md-0">
                        <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
                    </div>
                    --}}
                    <div class="table-responsive users-table">
                        <table class="table table-sm data-table">
                            <thead class="thead">
                                <tr>
                                    <th width="2%">No</th>
                                    <th width="20%">Mahasiswa</th>
                                    <th width="35%">Judul</th>
                                    <th width="5%">Rev</th>
                                    <th width="5%">Spv</th>
                                    <th width="15%">Tanggal Aktif</th>
                                    <th width="5%" class="text-right">SIAS</th>
                                    <!--<th width="15%" class="text-center">Surat Tugas</th>-->
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($researchs as $index => $research)
                                    <tr>
                                        <td>{{$index+1}}.</td>
                                        <td >
                                            {{$research->student->first_name}} {{$research->student->last_name}}
                                            <br>
                                            {{$research->student->program->code}}.{{$research->student->number}}
                                        </td>
                                        <td>{{$research->code}}-{{$research->id}}
                                            <br>
                                            {{$research->title}}
                                        </td>
                                        <td>
                                        @if($research->proposalReview->isNotEmpty())
                                                @foreach ($research->proposalReview  as $reviewer)
                                                    {{$reviewer->staff->code}}
                                                    <br>
                                                @endforeach
                                            @else
                                                @if(!is_null($research->supervisor))
                                                    @foreach ($research->supervisor as $supervisor)
                                                        {{$supervisor->staff->code}}
                                                        <br>
                                                    @endforeach
                                                @endif
                                            @endif
                                        </td>
                                        <td>
                                            @if(!is_null($research->supervisor))
                                                @foreach ($research->supervisor as $supervisor)
                                                    {{$supervisor->staff->code}}
                                                    <br>
                                                @endforeach
                                            @endif
                                        </td>
                                        <td>
                                            {{\carbon\Carbon::parse($research->active->created_at)->format('d F Y')}}
                                        </td>
                                        <td class="text-right">
                                            @if($research->SIASPro)
                                                @if($research->SIASPro->status == 1)
                                                    <i wire:click="SIASApprove({{$research->id}})" style="color:gray;cursor: pointer;" class="fa fa-check-circle fa-lg"></i>
                                                @endif
                                            @else
                                                <i style="color:green" class="fa fa-check-circle fa-lg"></i>
                                            @endif
                                        </td>
                                        <!--
                                        <td class="text-center">
                                            @if(!$expandViewIndex[$index])
                                                <i wire:click="expandView({{$index}}, {{$research->id}})" style="color:green;cursor: pointer;" class="fa fa-print fa-lg"></i>
                                            @endif
                                        </td>
                                        -->
                                    </tr>
                                    @if($expandViewIndex[$index])
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td colspan="7">
                                                <div x-data="{viewResearch : @entangle('viewResearch') }">
                                                    <div x-show="viewResearch">
                                                        <livewire:administration.research.proposal.view :wire:key="'$research->id'">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    @endif
                                @endforeach
                            </tbody>
                        </table>

                        {{$researchs->render()}}
                    </div>
                @else
                    Tidak ada data penelitian mahasiswa program studi
                    {{\App\Models\ArSys\Program::find($programId)->name}}
                    yang statusnya aktif dan memerlukan persetujuan di SIAS
                    dan pengajuan surat tugas pembimbing.
                @endif
            @else
                <i style="color: red">
                    Silakan pilih program study
                </i>
            @endif
        </div>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#program').on('change', function (e) {
                    let dataProgram = $(this).val();
                    @this.set('programId', dataProgram);
                    //console.log('here');
                    //window.livewire.emit('selectProgram');
                });
                window.livewire.on('reloadSelectProgram',()=>{
                    $('#program').select2('destroy');
                    $('#program').select2();
                });
            });
        </script>
    @endpush


</div>
