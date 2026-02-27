<div>
    <div wire:ignore.self class="modal fade" id="reviewExternalSupervisorModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-md" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reviewExternalSupervisorModal">Reviewer Assignment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12 offset-md-0">
                            @if($research !=null)
                                <b>{{$research->student->program->code}}.{{$research->student->number}}</b>
                                |
                                {{$research->student->first_name}} {{$research->student->last_name}}
                                <br>
                                <b>{{$research->code}}</b> | {{$research->type->description}}
                                <br>
                                <i>{!!$research->title!!}</i>
                            @endif
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 offset-md-0">
                            <div class="form-group">
                                <label for="externalSupervisor">External Supervisor</label>
                                <br>
                                <textarea rows="1" wire:model = "externalSupervisor" class="form-control"></textarea>
                                @error('externalSupervisor') <span class="text-danger">{{ $message }}</span>@enderror
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 offset-md-0">
                            <div class="form-group">
                                <label for="externalInstitution">Institution of External Supervisor</label>
                                <br>
                                <textarea rows="1" wire:model = "externalInstitution" class="form-control"></textarea>
                                @error('externalInstitution') <span class="text-danger">{{ $message }}</span>@enderror
                            </div>
                        </div>
                    </div>
                    <button class="btn btn-primary btn-xs" wire:click="assignExternalSupervisor"><i class="fa fa-save" aria-hidden="true"></i> Submit</button>
                    </button>
                </div>
           </div>
        </div>
        <script>
            window.livewire.on('reviewSetExternalSupervisorModal', () => {
                $('#reviewExternalSupervisorModal').modal('show');
            });
        </script>
    </div>
    
</div>
