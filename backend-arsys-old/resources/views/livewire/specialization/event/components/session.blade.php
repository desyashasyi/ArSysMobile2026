<div>
    <div wire:ignore.self class="modal fade" id="specializationEventSessionModal" tabindex="-1" role="dialog" aria-labelledby="studentApplyEventModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-sm modal-dialog-scrollable" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="specializationEventSessionModal">Event session</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    session: {{$sessions}}
                    @if($sessions->isNotEmpty())
                        <div class="table-responsive users-table">
                            <table class="table table-striped table-sm data-table">
                                <thead class="thead">
                                <tr>
                                    <td>
                                        No
                                    </td>
                                    <td>
                                        Time
                                    </td>
                                    <td class="text-right">
                                        Action
                                    </td>
                                </tr>
                                
                                </thead>
                                <tbody id="users-table">
                                    @foreach ($sessions as $index => $session)
                                    <tr>
                                        <td>
                                            {{$index+1}}.
                                        </td>
                                        <td>
                                            {{$session->time}}
                                        </td>
                                        <td class="text-right">
                                            @if($mode == 'Defense')
                                                @if($applicant->session_id == $session->id)
                                                    <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                        theme="default" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Selected" disabled/>
                                                @else
                                                    <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                        theme="success" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Select"/>
                                                @endif
                                            @endif
                                            @if($mode == 'Final-defense')
                                                @if($room->session_id == $session->id)
                                                    <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                        theme="default" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Selected" disabled/>
                                                @else
                                                    <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                        theme="success" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Select"/>
                                                @endif
                                            @endif

                                            @if($mode == 'Seminar')
                                            @if($room->session_id == $session->id)
                                                <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                    theme="default" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Selected" disabled/>
                                            @else
                                                <x-adminlte-button   wire:click="sessionSelect({{$session->id}})" 
                                                    theme="success" icon="fa fa-sm fa-check-circle" class="btn btn-xs" label="Select"/>
                                            @endif
                                        @endif
                                        </td>
                                    </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        {{$sessions->links()}}
                    @endif
                </div>
                <div class="modal-footer">
                </div>
    
           </div>
        </div>
    </div>
    <script>
        window.livewire.on('set_ArSysSpecializationEventSessionModal', () => {
            $('#specializationEventSessionModal').modal('show');
        });
    </script>
</div>
