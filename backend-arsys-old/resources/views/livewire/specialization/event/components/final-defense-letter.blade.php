<div>
    @if(is_null($finalDefenseLetter))
        <div  class="row">
            <div class="col-md-12 offset-sm-0">
                <div class="card card-outline card-orange">
                    <div wire:click="enableFinalDefenseProposal" style="color:green; cursor:pointer" class="card-header">
                        <b style="color: black">Final Defense proposal</b>&nbsp;&nbsp;
                        <i class="fa fa-md fa-arrow-circle-down"></i>
                    </div>
                </div>
            </div>
        </div>
    @else
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <div class="card card-outline card-orange">
                    <div wire:click="enableFinalDefenseProposal" style="color:red; cursor:pointer" class="card-header">
                        <b style="color: black">Final Defense proposal</b>&nbsp;&nbsp;
                        <i class="fa fa-md fa-arrow-circle-up"></i>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-md-4">
                                        <x-adminlte-input wire:model="yudiciumProposal" placeholder="Please input letter number" name="proposal" label="Yudicium proposal" style="width: 100%"/>
                                        @error('yudiciumProposal')
                                            <span class="text-danger">{{ $message }}</span><br>
                                        @enderror
                                    </div>
                                    <div class="col-md-4">
                                        <x-adminlte-input wire:model="deanInvitation" placeholder="Please input letter number" name="invitation" label="Dean Invitation" style="width: 100%"/>
                                        @error('deanInvitation')
                                            <span class="text-danger">{{ $message }}</span><br>
                                        @enderror
                                    </div>
                                    <div class="col-md-4">
                                        <x-adminlte-input wire:model="staffAssignment" placeholder="Please input letter number" name="invitation" label="Staff Assignment" style="width: 100%"/>
                                        @error('staffAssignment')
                                            <span class="text-danger">{{ $message }}</span><br>
                                        @enderror
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="text-left col-md-12">
                                        <x-adminlte-button wire:click="addLetter" theme="success"
                                            icon="fa fa-save" class="btn btn-xs btn-sm" label="Save" />
                                        @if($letterCount == 3)
                                            <x-adminlte-button wire:click="printProposal('YUDPRO')" theme="danger"
                                                icon="fa fa-print" class="btn btn-xs btn-sm" label="Print Yudicium Proposal" />
                                            <x-adminlte-button wire:click="printProposal('DEANINV')" theme="info"
                                                icon="fa fa-print" class="btn btn-xs btn-sm" label="Print Dean Invitation" />
                                            <x-adminlte-button wire:click="printProposal('STAFFASS')" theme="warning"
                                                icon="fa fa-print" class="btn btn-xs btn-sm" label="Print Staff Assignment" />
                                        @endif
                                    </div>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <livewire:specialization.event.components.final-defense-unregistered-applicant  :eventId="$eventId" :wire:key="'final-defense-unregistered-applicant-'.$eventId">
                    </div>
                </div>
            </div>
        </div>
    @endif
</div>
