<div>
    <div wire:ignore.self class="modal fade" id="addReviewerModal" tabindex="-1" role="dialog" aria-labelledby="reviewSetReviewerModal" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-xl" role="document">
           <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reviewSetReviewerModal">Reviewer Assignment</h5>
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

                                    @if($research->proposalReview != null)
                                        <b>Reviewer</b>

                                        <br>
                                        @php($counter = 0)
                                        @foreach ($research->proposalReview as $reviewer)
                                            {{++$counter}}.
                                            {{$reviewer->staff->first_name}} {{$reviewer->staff->last_name}}
                                            <button wire:click="unAssign({{ $reviewer->id }})" class="btn btn-xs"><i class="fa fa-user fa-user-minus" style ="color:red" aria-hidden="true"></i></button>
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
                                            {{--<th width="5%">No</th>
                                            <th width="15%">Code</th>
                                            <th width="55%">Name</th>
                                            <th width="15%">Aggregate</th>
                                            <th class="text-right" width="10%">Action</th>
                                            --}}
                                            <th rowspan="2" width="2%">No</th>
                                            <th rowspan="2" width="4%">Code</th>
                                            <th rowspan="2" width="23%">Name</th>
                                            <th rowspan="2" width="7%">Base</th>
                                            <th colspan="4" width="25%">
                                               Aggregate
                                            </th>
                                            @foreach($programs as $program)
                                                <th colspan="2" width="13%">
                                                    {{$program->abbrev}}
                                                </th>
                                            @endforeach

                                            <th rowspan="2" class="text-right" width="5%">Action</th>
                                        </tr>
                                        <tr>

                                            <th >
                                                All
                                            </th>
                                            <th >
                                                1st
                                            </th>
                                            <th >
                                                2nd
                                            </th>
                                            <th >
                                                <i style="color:red">Reviewer</i>
                                            </th>
                                            <th >
                                                1st
                                            </th>
                                            <th >
                                                2nd
                                            </th>
                                            <th>
                                                1st
                                            </th>
                                            <th >
                                                2nd
                                            </th>
                                            <th>
                                                1st
                                            </th>
                                            <th >
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
                                                <td>
                                                    @if($staff->program)
                                                        {{$staff->program->abbrev}}
                                                    @endif
                                                </td>
                                                {{--
                                                <td>
                                                    {{$staff->first_name}} {{$staff->last_name}}
                                                </td>
                                                --}}

                                                <td>
                                                    @if($staff->firstSPV->count() + $staff->secondSPV->count() != 0)
                                                        {{$staff->firstSPV->count() + $staff->secondSPV->count()}}
                                                    @endif
                                                </td>
                                                <td >
                                                    @if($staff->firstSPV->count() != 0)
                                                        {{$staff->firstSPV->count()}}
                                                    @endif
                                                </td>
                                                <td >
                                                    @if($staff->secondSPV->count() != 0)
                                                        {{$staff->secondSPV->count()}}
                                                    @endif
                                                </td>
                                                <td class="text-center">
                                                    <p style="color: red">
                                                        {{$staff->reviewer->count()}}
                                                    </p>
                                                </td>
                                                @foreach($programs as $program)
                                                    <td >
                                                        @php($count = null)
                                                        @foreach ($staff->firstSPV as $spv)
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
                                                    <td >
                                                        @php($count = null)
                                                        @foreach ($staff->secondSPV as $spv)
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
                                {{$staffs->links()}}
                            </div>
                        </div>
                    @endif
                </div>
                <div class="modal-footer">
                </div>
           </div>
        </div>
        <script>
            window.livewire.on('addReviewer_ArSysSpecializationResearchReviewerAddModal', () => {
                $('#addReviewerModal').modal('show');
            });
        </script>
    </div>

</div>

