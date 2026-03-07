<div>
    <div wire:key="arsys.student.research.components.warning">
        <div class="card card-outline card-warning">
            @if($research->SIASPro && !$research->programSeminar)
             
                <div class="card-body">
                    <div class="text-center col-sm-12 offset-sm-0">
                        <i style="color: red;">
                            You could not continue to the next research phase
                            before have approval of your research proposal 
                            <br>
                            in SIAS (https://siak.upi.edu/sias/).
                            <br>
                            To proceed, please submit it as soon as possible!
                        </i>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
