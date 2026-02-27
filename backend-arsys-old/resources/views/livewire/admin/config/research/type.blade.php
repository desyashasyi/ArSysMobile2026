{{--
@if(!is_null($researchTypes))
    <div class="row">
        <div class="text-left col-md-12">
            <b>Research Type</b>
        </div>
    </div>
    <br>
    <div class="row">
        <div class="text-left col-md-12">
            <div class="table-responsive users-table">
                <table class="table table-sm data-table">
                    <thead class="thead">
                        <tr>
                            <th width="5%">No</th>
                            <th width="10%">Code</th>
                            <th width="15%">Description</th>
                            <th width="15%">Research Model</th>
                            <th width="10%" class="text-center">Status</th>
                            <th width="10%" class="text-center">Number of supervisor</th>
                            <th width="10%" class="text-center">Duration</th>
                            <th width="10%" class="text-center">Duration Status</th>

                        </tr>
                    </thead>
                    <tbody>
                        @foreach($researchTypes as $index => $config)
                        <tr>
                            <td>
                                {{$index+1}}
                            </td>
                            <td>
                                {{$config->data->code}}
                            </td>
                            <td>
                                {{$config->data->description}}
                            </td>
                            <td>
                                {{$config->data->model->description}}
                            </td>
                            <td class="text-center">
                                @if($config->status)
                                    <button wire:click="setResearchTypeConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i></button>
                                @else
                                    <button wire:click="setResearchTypeConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i></button>
                                @endif
                            </td>
                            <td class="text-center">
                                {{$config->supervisor_number}}
                                &nbsp; &nbsp;
                                <i style="color:green;cursor: pointer;" wire:click="incSupervisorNumber({{$config->id}})" class="fa fa-xs fa-arrow-circle-up"></i>
                                <i style="color:green;cursor: pointer;" wire:click="decSupervisorNumber({{$config->id}})" class="fa fa-xs fa-arrow-circle-down"></i>
                            </td>
                            <td class="text-center">
                                {{$config->week_of_supervise}}
                                &nbsp; &nbsp;
                                <i style="color:green;cursor: pointer;" wire:click="incSuperviseDuration({{$config->id}})" class="fa fa-xs fa-arrow-circle-up"></i>
                                <i style="color:green;cursor: pointer;" wire:click="decSuperviseDuration({{$config->id}})" class="fa fa-xs fa-arrow-circle-down"></i>
                            </td>
                            <td class="text-center">
                                @if($config->enable_week_of_supervise)
                                    <button wire:click="setSuperviseDurationConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i></button>
                                @else
                                    <button wire:click="setSuperviseDurationConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i></button>
                                @endif
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <hr>
@endif
--}}

<div>
    <div class="row">
        <div class="col-md-12">
            @if($researchTypes->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th width="5%">No</th>
                                <th width="10%">Code</th>
                                <th width="30%">Description</th>
                                <th width="30%">Research Model</th>
                                <th width="10%" class="text-center">Status</th>
                                <th class="text-right" ="20%">Action</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchTypes as $index => $researchType)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td>
                                        {{$index+1}}
                                    </td>
                                    <td>
                                        {{$researchType->data->code}}
                                    </td>
                                    <td>
                                        {{$researchType->data->description}}
                                    </td>
                                    <td>
                                        {{$researchType->data->model->description}}
                                    </td>
                                    <td class="text-center">
                                        @if($researchType->status)
                                            <button wire:click="setResearchTypeConfig({{$researchType->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i></button>
                                        @else
                                            <button wire:click="setResearchTypeConfig({{$researchType->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i></button>
                                        @endif
                                    </td>
                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$researchType->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif
                                    </td>
                                    <td></td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="4">
                                            <div x-data="{viewResearchType : @entangle('viewResearchType') }">
                                                <div x-show="viewResearchType">
                                                    <livewire:admin.config.research.type-view :researchTypeId="$researchType->id" :wire:key="$researchType->id">
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                @endif
                           @endforeach
                        </tbody>
                    </table>
                </div>
                {{$researchTypes->render()}}
            @else
                No data
            @endif
        </div>
    </div>
</div>
