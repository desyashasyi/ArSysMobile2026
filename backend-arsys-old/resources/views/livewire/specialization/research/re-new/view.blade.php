<div>

    <div class="row" wire:key="arsys.specialization.research.re-new.view">
        <div class="col-md-12 offset-sm-0">
           <div class="card">
                <div class="card-header bg-warning">
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-5 border-right offset-md-0">
                            <b>Reviewer(s) of Student's Proposal</b>
                            <br>
                            @if(!is_null($research->proposalReview))
                                @foreach($research->proposalReview as $index => $review)
                                    @if($review->staff != null)
                                        {{$index+1}}. {{$review->staff->first_name}} {{$review->staff->last_name}}
                                        <br>
                                    @endif
                                @endforeach
                            @endif
                        </div>
                        <div class="col-md-7 offset-md-0">
                            <b>Supervisor of Student's Research</b>
                            <br>
                            @if(!is_null($research->supervisor))
                                @foreach($research->supervisor as $index => $supervisor)
                                    @if(!is_null($supervisor->staff))
                                        {{$index+1}}. {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                        <br>
                                    @endif
                                @endforeach
                                <hr>
                                @if($research->approval)
                                    <b>Research Approval History</b>
                                    <hr>
                                    @foreach($research->approval as $index => $approval)
                                        {{$index+1}}. The research activated at {{\Carbon\Carbon::parse($approval->created_at)->format('d F Y')}}
                                        <br>
                                    @endforeach
                                    <hr>
                                    @if($research->renewal)
                                        <x-adminlte-button class="btn-xs" theme="success"  wire:click="proceedToRenew({{$research->id}})" icon="fa fa-save" aria-hidden="true" label="Proceed to approve"/>
                                    @endif
                                @endif

                            @else
                                Research supervisor is not assigned
                            @endif
                        </div>
                    </div>
                    <hr>
                    <div class='row'>
                        <div class="col-md-12 offset-sm-0">
                            @if($research->remark->isNotEmpty())
                                <div x-data="{viewRemark : @entangle('viewRemark') }">
                                    @if(!$viewRemark)
                                        <div class="row">
                                            <div class="col-md-12 text-left">
                                                <u class="text-left" style="cursor:pointer; color:green" wire:click="viewRemark">View remark dan discussion</u>
                                            </div>
                                        </div>
                                    @endif
                                    <div x-show="viewRemark">
                                        <div class="row">
                                            <div class="col-md-12 text-left">
                                                <u style="cursor:pointer; color:red" wire:click="viewRemark">Hide remark dan discussion</u>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12 text-left">
                                                <livewire:specialization.research.components.remark :researchId="$researchId" :wire:key="'arsys.specialization.research.components.remark'">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
           </div>
        </div>
    </div>
</div>
