<div>
    <div x-data="{ addExaminer: @entangle('addExaminer') }">
        @if (!$addExaminer)
            <div class="row">
                <div class="text-left col-md-12">
                    <hr>
                    You can 
                    <button wire:click="enableAddExaminer" class="btn btn-sm"><i class="fa fa-sm fa-user-plus" style ="color:green" aria-hidden="true"></i> add examiner</button>
                        if there is an unpresented examiner.
                </div>
            </div>
        @endif
        <div x-show="addExaminer">
            <div class="row">
                <div class="col-md-12 offset-md-0 text-right">
                    <button wire:click="enableAddExaminer" class="btn btn-sm"><i class="fa fa-sm fa-ban" style ="color:red" aria-hidden="true"></i> close</button>

                </div>
            </div>

            <div class="row">
                <div class="col-md-12 offset-md-0">
                    @if($applicantId)
                        <div class="row">
                            <div class="col-md-12 offset-md-0" >
                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <thead class="thead">
                                        <tr>
                                            <th width="2%">No</th>
                                            <th width="3%">Code</th>
                                            <th width="25%">Name</th>
                                            <th width="5%">Base</th>
                                            <th class="text-right" width="5%">Action</th>
                                        </tr>
                                        
                                        </thead>
                                        <tbody id="users-table">
                                            @foreach ($staffs as $index => $staff)
                                            <tr>
                                                <td>
                                                    {{$index+1}}.
                                                </td>
                                                <td>
                                                    {{$staff->code}}
                                                </td>
                                                <td>
                                                    {{$staff->first_name}} {{$staff->last_name}}
                                                </td>
                                                <td>
                                                    @if($staff->program)
                                                        {{$staff->program->abbrev}}
                                                    @endif
                                                </td>
                    
                                                <td class="text-right">
                                                    <button wire:click="assignExaminer({{ $staff->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-plus" style ="color:green" aria-hidden="true"></i></button>
                                                </td>
                                            </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        {{$staffs->links()}}
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
