<div>
    
    <div class="row">
        <div class="text-left col-md-12">
            @if($researchs->isNotEmpty())
                <div class="col-md-3 offset-md-0">
                    <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
                </div>
                <br>
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="2%">No</th>
                                <th width="20%">Student</th>
                                <th width="30%">Title</th>
                                <th width="5%">Rev</th>
                                <th width="5%">Spv</th>
                                <th width="15%">Active Date</th>
                                <th width="5%" class="text-right">SIAS</th>
                                <th width="5%" class="text-right">Assignment</th>
                                <th width="1%">&nbsp;</th>
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
                                    <td class="text-right">
                                        @if($research->SIASPro)
                                            @if($research->SIASPro->status == 1)
                                            <x-adminlte-button   wire:click="printAssignment({{$research->id}})" 
                                                theme="success" icon="fa fa-sm fa-print" class="btn btn-sm" label="Print" disabled/>
                                            @endif
                                        @else
                                        <x-adminlte-button   wire:click="printAssignment({{$research->id}})" 
                                            theme="success" icon="fa fa-sm fa-print" class="btn btn-sm" label="Print"/>
                                        @endif
                                        
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    {{$researchs->render()}}
                </div>
            @else
                No data
            @endif  
        </div>
    </div>
</div>
