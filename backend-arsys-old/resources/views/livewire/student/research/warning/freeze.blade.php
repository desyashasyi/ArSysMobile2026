<div>
    <div wire:key="arsys.student.research.components.warning">
        <div class="card card-outline card-danger">
            @if($research->freeze)
               
                <div class="card-body">
                        <div class="text-center col-sm-12 offset-sm-0">
                            Your research is freeze. Please submit it for renewal 
                            <i wire:click="renewResearch" class="fa fa-arrow-circle-up fa-sm" style="color:green; cursor: pointer;"></i>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
