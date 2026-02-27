<div>
    @if($research)
        <div class="row">
            <div class="col-sm-12">
                @if($research->predefenseApproval->isNotEmpty() 
                    || $research->finaldefenseApproval->isNotEmpty()
                    || $research->seminarApproval->isNotEmpty())
                    <i class="fas fa-spinner"></i><b> Research Approval </b>
                    <br>         
                    @if($research->predefenseApproval->isNotEmpty())
                        @foreach($research->predefenseApproval as $index => $approval)
                            {{$index+1}}. {{$approval->staff->code}}-Pre defense&nbsp;
                                @if(Auth::user()->staff)
                                    @if($approval->staff->id == Auth::user()->staff->id)
                                        @if($approval->decision == null)
                                            <span style="color:gray; cursor: pointer;" wire:click="predefenseApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green; cursor: pointer;" wire:click="predefenseApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @else
                                        @if($approval->decision == null)
                                            <span style="color:gray; cursor: pointer;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green; cursor: pointer;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @endif
                                @endif

                                @if(Auth::user()->student)
                                    @if($approval->decision == null)
                                        <span style="color:gray;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @else
                                        <span style="color:green;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @endif
                                @endif
                            <br>
                        @endforeach
                    @endif

                    @if($research->finaldefenseApproval->isNotEmpty())
                        <hr>
                        @foreach($research->finaldefenseApproval as $index => $approval)
                            {{$index+1}}. {{$approval->staff->code}}-Final defense&nbsp;
                                @if(Auth::user()->staff)
                                    @if($approval->staff->id == Auth::user()->staff->id)
                                        @if($approval->decision == null)
                                            <span style="color:gray; cursor: pointer;" wire:click="finaldefenseApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green; cursor: pointer;" wire:click="finaldefenseApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @else
                                        @if($approval->decision == null)
                                            <span style="color:gray;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @endif
                                @endif

                                @if(Auth::user()->student)
                                    @if($approval->decision == null)
                                        <span style="color:gray;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @else
                                        <span style="color:green;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @endif
                                @endif
                            <br>
                        @endforeach
                    @endif
                    @if($research->seminarApproval->isNotEmpty())
                        <hr>
                        @foreach($research->seminarApproval as $index => $approval)
                            {{$index+1}}. {{$approval->staff->code}}-Seminar&nbsp;
                                @if(Auth::user()->staff)
                                    @if($approval->staff->id == Auth::user()->staff->id)
                                        @if($approval->decision == null)
                                            <span style="color:gray; cursor: pointer;" wire:click="seminarApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green; cursor: pointer;" wire:click="seminarApproval({{$approval->id}})"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @else
                                        @if($approval->decision == null)
                                            <span style="color:gray; cursor: pointer;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @else
                                            <span style="color:green; cursor: pointer;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                        @endif
                                    @endif
                                @endif

                                @if(Auth::user()->student)
                                    @if($approval->decision == null)
                                        <span style="color:gray;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @else
                                        <span style="color:green;"><i class="fas fa-md fa-check-circle"></i> Approved</span>
                                    @endif
                                @endif
                            <br>
                        @endforeach
                    @endif
                @endif
            </div>
        </div>
    @endif
</div>
