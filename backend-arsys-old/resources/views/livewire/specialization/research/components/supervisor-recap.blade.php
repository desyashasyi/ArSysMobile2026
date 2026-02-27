<div>
    <div x-data="{viewRecap : @entangle('viewRecap') }">
        <div x-show="!viewRecap">
            <div class="row" style="color:red;cursor: pointer;" wire:click="viewRecap">
                <div class="col-md-12">
                   Click this to show recap of supervision
                </div>
            </div>
        </div>
        <div x-show="viewRecap">
            <div class="text-left card">
                <div wire:click="viewRecap" class="card-header" style="color:green;cursor: pointer;">
                    Click to close
                </div>
                <div class="card-body">
                    @if(!is_null($staffs))
                        <div class="table-responsive users-table">
                            <table class="table table-sm data-table">
                                <thead class="thead">
                                    <tr>
                                        <th width="5%">No</th>
                                        <th width="20%">Staff</th>
                                        <th width="50%">Title</th>
                                        <th width="15%">Milestone</th>
                                        <th class="text-right" width="10%">Action</th>
                                        <th width="1%"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($staffs as $index => $staff)
                                        <tr>
                                            <td>
                                                {{$index+1}}.
                                            </td>
                                            <td>
                                                {{$staff->first_name}} {{$staff->last_name}}
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>                
                    @endif
                </div>
            </div>
        </div>
    </div>
    
</div>
