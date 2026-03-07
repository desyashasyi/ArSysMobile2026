<div>
    <div wire:ignore.self class="modal fade" id="specializationEventSpaceModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-md modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="specializationEventSpaceModal">Event space</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($spaces->isNotEmpty())
                        <div class="table-responsive users-table">
                            <table class="table table-striped table-sm data-table">
                                <thead class="thead">
                                <tr>
                                    <td>
                                        No
                                    </td>
                                    <td>
                                       Code
                                    </td>
                                    <td>
                                        Description
                                    </td>
                                    <td class="text-right">
                                        Action
                                    </td>
                                </tr>
                                
                                </thead>
                                <tbody id="users-table">
                                    @foreach ($spaces as $index => $space)
                                    <tr>
                                        <td>
                                            {{$index+1}}.
                                        </td>
                                        <td>
                                            {{$space->code}}
                                        </td>
                                        <td>
                                            {{$space->description}}
                                        </td>
                                        <td class="text-right">
                                            @if($mode == 'Defense')
                                                @if($applicant->space_id == $space->id)
                                                    <x-adminlte-button   wire:click="spaceSelect({{$space->id}})" 
                                                        theme="default" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Selected" disabled/>
                                                @else
                                                    <x-adminlte-button   wire:click="spaceSelect({{$space->id}})" 
                                                        theme="success" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Select"/>
                                                @endif
                                            @endif

                                            @if($mode == 'Final-defense')
                                            @if($room->space_id == $space->id)
                                                <x-adminlte-button   wire:click="spaceSelect({{$space->id}})" 
                                                    theme="default" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Selected" disabled/>
                                            @else
                                                <x-adminlte-button   wire:click="spaceSelect({{$space->id}})" 
                                                    theme="success" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Select"/>
                                            @endif
                                        @endif
                                        </td>
                                    </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        {{$spaces->links()}}
                    @endif
                </div>
                <div class="modal-footer">
                </div>
    
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('set_ArSysSpecializationEventSpaceModal', () => {
            $('#specializationEventSpaceModal').modal('show');
        });
    </script>
</div>
