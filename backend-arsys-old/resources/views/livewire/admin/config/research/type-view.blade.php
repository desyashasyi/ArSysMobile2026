<div>
    @if($researchType)
        <div class="col-md-12 offset-sm-0">
            <div class="card">
                <div class="card bg-success">
                    &nbsp;
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-12 offset-md-0">
                            <div class="table-responsive users-table">
                                <table class="table table-sm data-table">
                                    <tbody>
                                        @foreach($researchType->examination as $index => $examination)
                                         <tr>
                                            <td width="5%">
                                                {{$index+1}}.
                                            </td>
                                            <td width="20%">
                                                {{$examination->event->code}}
                                            </td>
                                            <td width="20%">
                                                {{$examination->event->examination_type}}
                                            </td>
                                            <td width="30%">
                                                {{$examination->event->description}}
                                            </td>
                                            <td class="text-right" width="25%">
                                                <x-adminlte-button theme="warning" icon="fa fa-xs fa-edit" 
                                                    class="btn btn-xs" label="Edit"/>
                                            </td>
                                         </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    @endif
</div>
