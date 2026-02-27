<div>
    <div wire:ignore.self class="modal fade" id="addSupervisorModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-xl" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSupervisorModal">Supervisor Assignment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    @if($research )
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
                                    <br>
                                    <br>

                                    @if($research->supervisordummy != null)
                                        <b>Supervisor</b>
                                        <br>
                                        @php($counter = 0)
                                        @if($research->supervisor != null)
                                            @foreach ($research->supervisor as $supervisor)
                                                {{++$counter}}.
                                                {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                                <br>
                                            @endforeach
                                        @endif
                                        @foreach ($research->supervisordummy as $supervisor)
                                            {{++$counter}}.
                                            {{$supervisor->staff->first_name}} {{$supervisor->staff->last_name}}
                                            <button wire:click="unAssign({{ $supervisor->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
                                            <br>
                                        @endforeach
                                    @endif
                                @endif
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-5 offset-md-0">
                                <input wire:model="search" type="text" class="my-3 form-control" placeholder="Search staff name">
                            </div>
                        </div>
                        {{--
                        <div class="row">
                            <div class="col-md-6 offset-md-0">
                                @if($includeCluster)
                                    <button wire:click="includeCluster" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i> Include cluster</button>
                                @else
                                    <button wire:click="includeCluster" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i> Include cluster</button>
                                @endif
                            </div>
                        </div>
                        --}}
                        <div class="row">
                            <div class="col-md-12 offset-md-0" style="width: 100%; height: 230px; overflow-y: scroll; overflow-x: hidden">

                                <div class="table-responsive users-table">
                                    <table class="table table-striped table-sm data-table">
                                        <thead class="thead">
                                        <tr>

                                            <th rowspan="2" width="2%">No</th>
                                            <th rowspan="2" width="4%">Code</th>
                                            <th rowspan="2" width="23%">Name</th>
                                            <th class="text-center" rowspan="2" width="7%">Base</th>
                                            <th class="text-center" colspan="5" width="25%">
                                               Aggregate
                                            </th>
                                            @foreach($programs as $program)
                                                <th class="text-center" colspan="2" width="13%">
                                                    {{$program->abbrev}}
                                                </th>
                                            @endforeach

                                            <th rowspan="2" class="text-right" width="5%">Action</th>
                                        </tr>
                                        <tr>

                                            <th class="text-center">
                                               <b style="color:blue">All</b>
                                            </th>
                                            <th class="text-center">
                                                <i style="color:red">Active</i>
                                            </th>
                                            <th class="text-center">
                                                1st
                                            </th>
                                            <th class="text-center">
                                                2nd
                                            </th>
                                            <th class="text-center">
                                                <i style="color:red">Reviewer</i>
                                            </th>
                                            <th class="text-center">
                                                1st
                                            </th>
                                            <th class="text-center">
                                                2nd
                                            </th>
                                            <th class="text-center">
                                                1st
                                            </th>
                                            <th class="text-center">
                                                2nd
                                            </th>
                                            <th class="text-center">
                                                1st
                                            </th>
                                            <th class="text-center">
                                                2nd
                                            </th>
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
                                                <td class="text-center">
                                                    @if($staff->program)
                                                        {{$staff->program->abbrev}}
                                                    @endif
                                                </td>
                                                {{--
                                                <td>
                                                    {{$staff->first_name}} {{$staff->last_name}}
                                                </td>
                                                --}}

                                                <td class="text-center">
                                                    <p style="color: blue">
                                                        <b>{{$staff->firstSPV->count() + $staff->secondSPV->count()}}</b>
                                                    </p>
                                                </td>
                                                <td class="text-center">
                                                    <p style="color: red">
                                                        {{$staff->firstSPVActive->count() + $staff->secondSPVActive->count()}}
                                                    </p>
                                                </td>
                                                <td class="text-center">
                                                    @if($staff->firstSPVActive->count() != 0)
                                                        {{$staff->firstSPVActive->count()}}
                                                    @endif
                                                </td>
                                                <td class="text-center">
                                                    @if($staff->secondSPVActive->count() != 0)
                                                        {{$staff->secondSPVActive->count()}}
                                                    @endif
                                                </td>
                                                <td class="text-center">
                                                    <p style="color: red">
                                                        {{$staff->reviewer->count()}}
                                                    </p>
                                                </td>
                                                @foreach($programs as $program)
                                                    <td class="text-center">
                                                        @php($count = null)
                                                        @foreach ($staff->firstSPVActive as $spv)
                                                            @if(!is_null($spv->research))
                                                                @if($spv->research->student->program_id ==  $program->id)
                                                                    @php($count++)
                                                                @endif
                                                            @endif
                                                        @endforeach
                                                        @if($count != 0)
                                                            @if($staff->program_id == $program->id)
                                                                <b>{{$count}}</b>
                                                            @else
                                                                {{$count}}
                                                            @endif
                                                        @endif
                                                    </td>
                                                    <td class="text-center">
                                                        @php($count = null)
                                                        @foreach ($staff->secondSPVActive as $spv)
                                                            @if(!is_null($spv->research))
                                                                @if($spv->research->student->program_id ==  $program->id)
                                                                    @php($count++)
                                                                @endif
                                                            @endif
                                                        @endforeach
                                                        @if($count != 0)
                                                            @if($staff->program_id == $program->id)
                                                                <b>{{$count}}</b>
                                                            @else
                                                                {{$count}}
                                                            @endif
                                                        @endif
                                                    </td>
                                                @endforeach

                                                <td class="text-right">
                                                    <button wire:click="assign({{ $staff->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-plus" style ="color:green" aria-hidden="true"></i></button>
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
                <div class="modal-footer">
                </div>
           </div>
        </div>
        <script>
            window.livewire.on('addSupervisor_ArSysSpecializationResearchSupervisorAddModal', () => {
                $('#addSupervisorModal').modal('show');
            });
        </script>
    </div>
</div>

