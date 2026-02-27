<div>
    <div class="row">
        <div class="col-md-12 text-left">
            <div x-data="{enableSpecialization : @entangle('enableSpecialization') }">
                <div x-show="enableSpecialization">
                    <br>
                    <livewire:admin.config.institution.specialization.create>
                    <br>
                    @if($specializations->isNotEmpty())
                    <div class="row">
                        <div class="col-md-12 text-left">
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <thead class="thead">
                                        <tr>
                                            <th width="5%">No.</th>
                                            <th width="5%">Code</th>
                                            <th width="65%">Description</th>
                                            <th width="10%">Head</th>
                                            <th class="text-right" width="25%">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach ($specializations as $index => $specialization)
                                            <tr>
                                                <td>
                                                    {{$index+1}}
                                                </td>
                                                <td>
                                                    {{$specialization->code}}
                                                </td>
                                                <td>
                                                    {{$specialization->description}}
                                                </td>
                                                <td>
                                                    @if($specialization->head)
                                                        {{$specialization->head->code}}
                                                    @endif
                                                </td>
                                                <td class="text-right">
                                                    <x-adminlte-button   wire:click="editSpecialization({{$index}}, {{$specialization->id}})"
                                                        theme="warning" icon="fa fa-xs fa-edit" class="btn btn-xs" label="Edit"/>
                                                    <x-adminlte-button   wire:click="deleteSpecialization({{$specialization->id}})"
                                                        theme="danger" icon="fa fa-xs fa-trash" class="btn btn-xs" label="Delete"/>
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    @endif
                </div>
                <div x-show="!enableSpecialization">
                    <i style="color: red">The specializaiton is disabled</i>
                </div>
            </div>
        </div>
    </div>
</div>
