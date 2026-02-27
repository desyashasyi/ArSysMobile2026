<div>
    {{-- Care about people's approval and you will be their prisoner. --}}
    <div class="row">
        <div class="col-md-6 offset-md-0">
            <input wire:model="search" type="text" class="my-3 form-control" placeholder="Search staff">
        </div>
    </div>
    <div class="table-responsive users-table">
        <table class="table table-striped table-sm data-table">
            <thead class="thead">
            <tr>
                <th width="10%">Code</th>
                <th width="40%">Name</th>
                <th class="text-right" width="10%">Action</th>

            </tr>
            </thead>
            <tbody id="users-table">
                @foreach ($staffs as $staff)
                <tr>
                    <td>
                        {{$staff->code}}
                    </td>
                    <td>
                        {{$staff->first_name}} {{$staff->last_name}}
                    </td>

                    
                    <td class="text-right">
                        <i wire:click="$emitUp('pickUpStaffName', {{$staff->id}})" style="color: green; cursor: pointer;" class="fa fa-sm fa-user-plus">
                        </i>
                    </td>
                </tr>
                @endforeach
            </tbody>
        </table>
        {{$staffs->render()}}
    </div>
</div>
