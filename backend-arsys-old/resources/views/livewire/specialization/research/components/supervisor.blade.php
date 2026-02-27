<div>
    <div class ="row">
        <div class="col-md-12 offset-md-0">
            <b>Supervisor of Student's Research</b>
            <br>
            @if($research)
                @if($research->supervisordummy->isEmpty())
                    <i>The research supervisor should be assigned</i>
                @endif
            @endif
            <hr>
            @if($research)
                @php($counter = 0)
                @foreach($research->supervisordummy as $supervisor)
                    {{++$counter}}. {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                    <button wire:click="$emit('unAssignSupervisor_ArSysSpecializationResearchComponentsModalSupervisorAdd', {{ $supervisor->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                    <br>
                @endforeach
                @if(\App\Models\ArSys\ResearchSupervisorDummy::where('research_id', $researchId)->get()->count()
                <  \App\Models\ArSys\Research::where('id', $researchId)->first()->type->supervisor_number)
                    <x-adminlte-button  class="btn-xs" theme="info" wire:click="$emit('supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd',{{$researchId}})" icon="fa fa-user-plus" label="Assign"/>
                @endif

                @if(\App\Models\ArSys\ResearchSupervisorDummy::where('research_id', $researchId)->get()->count()
                >=  \App\Models\ArSys\Research::where('id', $researchId)->first()->type->supervisor_number
                && $research->supervisorExtra)
                    @if($research->supervisorExtra->status == 1)
                        <x-adminlte-button  class="btn-xs" theme="info" wire:click="$emit('supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd',{{$researchId}})" icon="fa fa-user-plus" label="Assign"/>
                    @endif
                @endif

                @if($proceedToApprove == 1)
                    <x-adminlte-button class="btn-xs" theme="success"  wire:click="proceedToApprove" icon="fa fa-save" aria-hidden="true" label="Proceed to approve"/>
                @endif


                <hr>
                @if($research->supervisorExtra)
                    @if($research->supervisorExtra->status == 1)
                        <button wire:click="setSupervisorExtra({{$researchId}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i> Extra and External Supervisor</button>
                    @else
                        <button wire:click="setSupervisorExtra({{$researchId}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" style ="color:gray" aria-hidden="true"></i> Extra and External Supervisor</button>
                    @endif
                @else
                    <button wire:click="setSupervisorExtra({{$researchId}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" style ="color:gray" aria-hidden="true"></i> Extra and External Supervisor</button>
                @endif



                @if($research->supervisorExtra)
                    @if($research->supervisorExtra->status == 1)
                        <hr>
                        <b>External Supervisor:</b>
                        <br>
                        @if($research->supervisorexternaldummy != null )
                            {{$research->supervisorexternaldummy->supervisor_name}} -
                            {{$research->supervisorexternaldummy->institution}}
                            <button wire:click="$emit('unAssignExternalSupervisor_ArSysSpecializationResearchComponentsModalSupervisorExternallAdd', {{ $research->supervisorexternaldummy->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                            <br>
                        @endif
                            <x-adminlte-button class="btn-xs" theme="info"  wire:click="$emit('externalSupervisor_ArSysSpecializationResearchNew', {{$researchId}})" icon="fa fa-user-plus" aria-hidden="true" label="Add/Edit"/>
                    @endif
                @endif
            @endif
        </div>
    </div>
    <livewire:specialization.research.components.modal.supervisor-add>
    <livewire:specialization.research.components.modal.supervisor-external-add>
</div>
