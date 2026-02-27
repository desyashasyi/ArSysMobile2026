<div>
    <div class="row">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="20%">Student</th>
                                <th width="50%">Title</th>
                                <th width="15%">Milestone</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                    </td>
                                    <td>
                                        {{$research->code}}-{{$research->id}}
                                        <br>
                                        {{$research->title}}
                                    </td>
                                    <td>
                                        @if($research->milestone)
                                            <b>{{ $research->milestone->code }}</b>
                                        @endif
                                        <hr>
                                        @if($research->reviewer->isNotEmpty())
                                            @foreach($research->reviewer as $reviewer)
                                                @if($reviewer->decision_id == 
                                                    \App\Models\ArSys\ResearchReviewDecisionType::where('code', 'RJC')->first()->id)
                                                    <span class="badge badge-pill badge-danger">
                                                        {{$reviewer->staff->code}}-{{$reviewer->decision->description}}
                                                    </span>
                                                @endif           
                                            @endforeach 
                                        @else
                                            @if($research->rejected)
                                                <span class="badge badge-pill badge-danger">
                                                    {{ $research->rejected->message }}
                                                </span>
                                            @endif
                                        @endif
                                    </td>
                                </tr>    
                                
                           @endforeach
                        </tbody>
                    </table>
                    {{$researchs->links()}}
                </div>
            @else
                No data
            @endif      
        </div>
    </div>
</div>