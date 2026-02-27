<div>
    <div wire:key="arsys.student.research.components.warning">
        <div class="card card-outline card-danger">
            @if($research->rejected)
              
                <div class="card-body">
                        <div class="text-center col-sm-12 offset-sm-0">
                            Your research is rejected, most of rejected proposal due to some factors:
                            <br>
                            1. The topic is already researched (repetitive)
                            <br>
                            2. The topic is ilogical or is not suitable for undergraduate student research
                            <br>
                            Please submit another one 
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
</div>
