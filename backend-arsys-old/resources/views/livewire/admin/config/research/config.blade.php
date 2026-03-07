@if(!is_null($configs))
    <div class="row">
        <div class="text-left col-md-12">
            <b>Research Config</b>
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
                            <th width="20%">Code</th>
                            <th width="55%">Description</th>
                            <th width="10%">Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($configs as $index => $config)
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
                                @if($config->status)
                                    <button wire:click="setConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-on" style ="color:green" aria-hidden="true"></i></button>
                                @else
                                    <button wire:click="setConfig({{$config->id}})" class="btn btn-sm"><i class="fa fa-lg fa-toggle-off" aria-hidden="true" style ="color:gray"></i></button>
                                @endif
                            </td>
                            <td>

                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>    
        </div>
    </div>
@endif            