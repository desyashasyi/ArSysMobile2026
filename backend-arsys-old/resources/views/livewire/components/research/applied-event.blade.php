<div>
    @include('livewire.components.research.applied-event-modal')
    @if($research)
        <hr>
        @if(!is_null($research->seminarApplied) || !is_null($research->predefenseApplied) || !is_null($research->finaldefenseApplied))
            <div class="row">
                <div class="col-md-12 offset-md-0">
                    <b>Applied Event</b>
                    <br>
                </div>
            </div>
        @endif
        @if(!is_null($research->predefenseApplied))
            <div class="row">
                <div class="col-md-12 offset-md-0">
                    @if(!is_null($research->predefenseApplied))
                        {{$research->predefenseApplied->event->type->description}}
                        {{\Carbon\Carbon::parse($research->predefenseApplied->event->event_date)->format('d-m-Y') }}

                        @if(Auth::user()->student)
                            @if(Auth::user()->student->id == $research->student->id)
                                @if($research->predefenseUnconfirmed)
                                    &nbsp;|&nbsp; <i class="fa fa-md fa-edit" style="cursor: pointer;color:orange"
                                    wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})"></i>
                                @endif
                            @endif
                        @endif

                        @if(!$research->predefenseUnconfirmed)
                            <span style="cursor: pointer;color:green"
                            wire:click="showAppliedEvent({{$research->predefenseApplied->event_id}})"><i class="fa fa-md fa-eye"></i> show</span>
                        @endif
                    @endif
                </div>
            </div>
        @endif

        @if(!is_null($research->seminarApplied))
            <div class="row">
                <div class="col-md-12 offset-md-0">
                    @if(!is_null($research->seminarApplied))
                        {{$research->seminarApplied->event->type->description}}
                        <br>
                        {{\Carbon\Carbon::parse($research->seminarApplied->event->event_date)->format('d-m-Y') }}
                        &nbsp;|&nbsp;
                        @if(Auth::user()->student)
                            @if(Auth::user()->student->id == $research->student->id)
                                @if($research->seminarUnconfirmed)
                                    <i class="fa fa-md fa-edit" style="cursor: pointer;color:orange"
                                    wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})"></i>
                                @endif
                            @endif
                        @endif

                        @if(!$research->predefenseUnconfirmed)
                            <span style="cursor: pointer;color:green"
                            wire:click="showAppliedEvent({{$research->seminarApplied->event_id}})"><i class="fa fa-md fa-eye"></i> show</span>
                        @endif
                    @endif
                </div>
            </div>
        @endif

        @if(!is_null($research->finaldefenseApplied))
            <div class="row">
                <div class="col-md-12 offset-md-0">
                    @if(!is_null($research->finaldefenseApplied))
                        {{$research->finaldefenseApplied->event->type->description}}
                        {{\Carbon\Carbon::parse($research->finaldefenseApplied->event->event_date)->format('d-m-Y') }}
                        &nbsp;|&nbsp;
                        @if(Auth::user()->student)
                            @if(Auth::user()->student->id == $research->student->id)
                                @if($research->finaldefenseUnconfirmed)
                                    <i class="fa fa-md fa-edit" style="cursor: pointer; color:orange"
                                    wire:click="$emit('applyEvent_StudentResearchAction',{{$researchId}})"></i>
                                @endif
                            @endif
                        @endif

                        @if(!$research->finaldefenseUnconfirmed)
                            <span style="cursor: pointer;color:green"
                            wire:click="showAppliedEvent({{$research->finaldefenseApplied->event_id}})"><i class="fa fa-md fa-eye"></i> show</span>
                        @endif
                    @endif
                </div>
            </div>
        @endif
    @endif
</div>
