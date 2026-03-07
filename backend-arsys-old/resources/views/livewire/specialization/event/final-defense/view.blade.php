<div>
    @if($eventApplicants->isNotEmpty())
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <livewire:specialization.event.components.final-defense-letter :eventId="$eventId" :wire:key="'final-defense-letter-'.$eventId">
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 offset-sm-0">
                <livewire:specialization.event.components.final-defense-rooms  :eventId="$eventId" :wire:key="'final-defense-rooms-'.$eventId">
            </div>
        </div>
    @endif
    <div class="row">
        <div class="col-md-12 offset-sm-0">
            <div class="card card-outline card-success">
                <div class="card-header">
                    <b>Final Defense Applicant</b>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12 offset-sm-0">
                            <livewire:specialization.event.final-defense.components.applicant-add  :eventId="$eventId" :wire:key="'final-defense-applicant-'.$eventId">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-md-12 offset-sm-0">
                            @if($eventApplicants->isNotEmpty())
                                <div class="table-responsive users-table">
                                    <table class="table table-sm data-table">
                                        <thead class="thead">
                                            <tr>
                                                <td class="bg-orange" width="1%"></td>
                                                <th class="text-right" width="4%">No</th>
                                                <th width="30%">Student</th>
                                                <th width="50%">Research</th>
                                                <th class="text-right" width="15%">Action</th>
                                            </tr>
                                        </thead>
                                        <div style="overflow-y: scroll; overflow-x: hidden">
                                            <tbody>
                                                @foreach ($eventApplicants as $index => $applicant)
                                                    @if($index%2 == 0)
                                                        <tr class="bg-light">
                                                    @else
                                                        <tr>
                                                    @endif
                                                    @if(is_null($applicant->publish))
                                                        <td class="bg-gray">
                                                        </td>
                                                    @else
                                                        <td class="bg-green">
                                                        </td>
                                                    @endif
                                                    <td class="text-right">
                                                        {{$index+1}}.
                                                    </td>
                                                    <td>
                                                        @if($applicant->research->student->program != null)
                                                            {{$applicant->research->student->program->code}}.{{$applicant->research->student->number}}
                                                        @endif
                                                        <br>
                                                        {{$applicant->research->student->first_name}} {{$applicant->research->student->last_name}}
                                                    </td>
                                                    <td>
                                                        <b>{{$applicant->research->code}}-{{$applicant->research->id}}</b>
                                                        <br>
                                                        {!!$applicant->research->title!!}
                                                    </td>
                                                    <td class="text-right">
                                                        @if($applicant->research->student->program_id == Auth::user()->staff->program_id)
                                                            @if($applicant->confirmed == 1)
                                                                <span style="color:gray">
                                                                    <i class="fas fa-xs fa-check-circle" ></i>
                                                                    <u>confirmed</u>
                                                                </span>
                                                            @else
                                                                <span wire:click="confirm({{$applicant->id}})" style="cursor: pointer;color:green">
                                                                    <i style="color:green" class="fas fa-xs fa-check-circle" ></i>
                                                                    <u>confirm</u>
                                                                </span>
                                                            @endif
                                                            <br>
                                                            <span wire:click="$emit('change_ArSysSpecializationEvent', {{$applicant->id}}, {{$applicant->event->type->id}})" style="cursor: pointer;color:green">
                                                                <i style="color:green" class="fas fa-xs fa-edit" ></i>
                                                                <u>change</u>
                                                            </span>
                                                        @else
                                                            no access
                                                        @endif
                                                    </td>
                                                </tr>
                                                    @if($applicant->confirmed == 1)
                                                        <tr>
                                                            <td colspan="3"></td>
                                                            <td colspan="3">
                                                                <div class="table-responsive users-table">
                                                                    <table class="table table-sm data-table">
                                                                        <thead class="thead">
                                                                            <tr>
                                                                                <th class="text-left" width="15%">SPV(s)</th>
                                                                                <th class="text-left" width="15%">
                                                                                    EX(s)
                                                                                </th>
                                                                                <th class="text-left" width="70%">
                                                                                    Room selection
                                                                                </th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="text-left">
                                                                                    @if($applicant->research->supervisor != null)
                                                                                        @forelse ($applicant->research->supervisor as $supervisor)

                                                                                            {{$supervisor->staff->code}}

                                                                                            <br>
                                                                                        @empty
                                                                                        @endforelse
                                                                                    @endif
                                                                                </td>
                                                                                <td class="text-left">
                                                                                    @if($applicant->confirmed == 1)
                                                                                        @if(!is_null($applicant->research->predefenseApplied->defenseExaminer))
                                                                                            @foreach ($applicant->research->predefenseApplied->defenseExaminer as $index => $examiner)
                                                                                                <div class="row">
                                                                                                    <div class="col col-md-12 text-left">
                                                                                                        <span wire:click="setFirstExaminer({{$applicant->id}}, {{$examiner->examiner_id}})" style="cursor:pointer;">
                                                                                                        @if($examiner->order == 1)
                                                                                                            <sup>
                                                                                                                <i class="fa fa-sm fa-star" style="color: green;"></i>
                                                                                                            </sup>
                                                                                                        @else
                                                                                                            <sup>
                                                                                                                <i class="fa fa-sm fa-star" style="color: gray;"></i>
                                                                                                            </sup>
                                                                                                        @endif
                                                                                                        {{$examiner->staff->code}}
                                                                                                        </span>
                                                                                                    </div>
                                                                                                </div>
                                                                                            @endforeach
                                                                                        @endif
                                                                                    @endif
                                                                                </td>
                                                                                <td>
                                                                                    @php($iterator = 0)
                                                                                    @foreach($rooms as $room)
                                                                                        @php($iterator++)
                                                                                        @if($applicant->room_id == $room->id)
                                                                                        <x-adminlte-button wire:click="assignApplicant({{$room->id}}, {{$applicant->id}})" theme="default"
                                                                                            icon="fa fa-building" class="btn btn-xs btn-sm" label="P-{{$iterator}} ({{$room->applicant->count()}})" disabled />
                                                                                        @else
                                                                                            <x-adminlte-button wire:click="assignApplicant({{$room->id}}, {{$applicant->id}})" theme="success"
                                                                                                icon="fa fa-building" class="btn btn-xs btn-sm" label="P-{{$iterator}} ({{$room->applicant->count()}})" />
                                                                                        @endif
                                                                                    @endforeach

                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>

                                                    @endif
                                                @endforeach
                                            </tbody>
                                        </div>

                                    </table>
                                </div>
                                {{$eventApplicants->render()}}
                            @else
                                No applicant data
                            @endif
                        </div>
                    </div>
                    <livewire:specialization.event.components.change>
                </div>
            </div>
        </div>
    </div>
</div>
