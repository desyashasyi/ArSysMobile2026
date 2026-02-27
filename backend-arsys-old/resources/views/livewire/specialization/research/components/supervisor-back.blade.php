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
                <br>
                @if(\App\Models\ArSys\ResearchSupervisorDummy::where('research_id', $researchId)->get()->count() +
                (\App\Models\ArSys\ResearchSupervisorExternalDummy::where('research_id', $researchId)->get()->count()
                <  \App\Models\ArSys\Research::where('id', $researchId)->first()->type->supervisor_number+1))

                    <x-adminlte-button  class="btn-xs" theme="info" wire:click="$emit('supervisorAdd_ArSysSpecializationResearchComponentsModalSupervisorAdd',{{$researchId}})" icon="fa fa-user-plus" label="Assign"/>
                    @if ($research->supervisordummy()->count() +  $research->supervisorexternaldummy()->count() == 2)
                        <x-adminlte-button class="btn-xs" theme="info"  wire:click="proceedToApprove" icon="fa fa-save" aria-hidden="true" label="Proceed to approve"/>
                    @endif
                @endif

                @if(\App\Models\ArSys\ResearchSupervisorDummy::where('research_id', $researchId)->get()->isNotEmpty() &&
                    (\App\Models\ArSys\ResearchSupervisorDummy::where('research_id', $researchId)->get()->count()
                    <  \App\Models\ArSys\Research::where('id', $researchId)->first()->type->supervisor_number))

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
        </div>
    </div>
    <livewire:specialization.research.components.modal.supervisor-add>
    <livewire:specialization.research.components.modal.supervisor-external-add>
</div>
