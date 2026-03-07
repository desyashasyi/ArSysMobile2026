<div>
    <div wire:key="arsys.student.research.components.warning">
        <div class="card">
            @if($research->freeze)
                <div class="card bg-red">
                    &nbsp;
                </div>
                <div class="card-body">
                        <div class="col-sm-12 offset-sm-0 text-center">
                            Your research is freeze. Please submit it for renewal 
                            <i wire:click="renewResearch" class="fa fa-arrow-circle-up fa-sm" style="color:green; cursor: pointer;"></i>
                        </div>
                    </div>
                </div>
            @elseif($research->renewal)
                <div class="card bg-warning">
                    &nbsp;
                </div>
                <div class="card-body">
                    <div class="col-sm-12 offset-sm-0 text-center">
                        Your research has been submitted for renewal, please wait for a while.
                    </div>
                </div>
            @elseif($research->SIASPro && !$research->programSeminar)
                <div class="card bg-warning">
                    &nbsp;
                </div>
                <div class="card-body">
                    <div class="col-sm-12 offset-sm-0 text-center">
                        <i style="color: red;">
                            You could not continue to the next research phase
                            before have approval of your research proposal in SIAS.
                            <br>
                            To proceed, please submit it as soon as possible!
                        </i>
                    </div>
                </div>
                
            @endif
        </div>
    </div>
</div>
