<div>
    <div class="row">
        <div class="col-md-12 offset-md-0">
            <b>Reviewer(s) of Student's Proposal</b>
            <br>
            @if($research)
                @if($research->proposalReview->isEmpty())
                    <i>The proposal reviewer might be assigned</i>
                    <br>
                @endif
            @endif
            <hr>
            @if($research)
                @if($research->proposalReview->isNotEmpty())
                    @php($counter = 0)
                    @foreach($research->proposalReview as $review)
                        @if($review->staff != null)
                            {{++$counter}}. {{$review->staff->first_name}} {{$review->staff->last_name}}
                            <button wire:click="$emit('unAssignReviewer_ArSysSpecializationResearchComponentsModalReviewerAdd', {{ $review->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                            <br>
                        @endif
                    @endforeach
                @endif
                <x-adminlte-button class="btn-xs" theme="info" wire:click="$emit('reviewerAdd_ArSysSpecializationResearchComponentsModalReviewerAdd', {{$research->id}})" icon="fa fa-user-plus" label="Assign"/>
                @if(is_null($research->review) && $research->proposalReview->isNotEmpty())
                    <x-adminlte-button class="btn-xs" theme="info"  wire:click="proceedToReview({{$research->id}})" icon="fa fa-save" aria-hidden="true" label="Proceed to review"/>
                @endif
                <x-adminlte-button class="btn-xs" theme="danger"  wire:click="reject({{$research->id}})" icon="fa fa-trash" aria-hidden="true" label="Reject"/>

            @endif
        </div>
    </div>
    <livewire:specialization.research.components.modal.reviewer-add :wire:key="'$research->id'">
</div>
