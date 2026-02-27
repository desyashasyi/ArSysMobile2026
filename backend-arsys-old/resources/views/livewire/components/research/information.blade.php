<div>
    @if($research)
        <div class="row">
            <div class="col-sm-12">
                @if(!is_null($research))
                    @if($research->milestone)
                        @if(\Carbon\Carbon::parse($research->approval_date)->addDay(180)->gte(\Carbon\Carbon::now()))
                            <i style="color: green;" class="fa fa-exclamation-circle"></i>
                            {{$research->milestone->description}}
                            @if(Auth::user()->student)
                                @if(Auth::user()->student->id == $research->student_id)
                                    @if($research->milesPREDEFDONE)
                                        <hr>
                                        <i style="color: red;">
                                            You should submit the defense/seminar report before continue to the next phase.
                                        </i>
                                    @endif
                                @endif
                            @endif
                        @elseif($research->milestone->sequence !=  \Modules\ArSys\Entities\ResearchMilestone::where('phase', 'Graduated')->first()->sequence)
                            <i>Research is Suspended</i>
                        @endif
                    @endif
                @endif
            </div>
        </div>
    @endif            
</div>

