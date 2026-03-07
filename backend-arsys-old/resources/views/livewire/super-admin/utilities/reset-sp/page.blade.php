<div>
    <div class="row">
        <div class="col-md-12">
            @foreach ($researchTypes as $type)
                <span class="badge bg-{{$type->base->color}}">{{$type->base->code}}-{{$type->base->description}}</span>
                &nbsp;
            @endforeach
        </div>
    </div>
    <br>

    <div class="row">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th></th>
                                <th width="5%">No</th>
                                <th width="20%">Student</th>
                                <th width="50%">Title</th>
                                <th width="15%">Milestone</th>
                                <th class="text-right" width="10%">Action</th>
                                <th width="1%"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td class="bg-{{$research->type->base->color}}"></td>
                                    <td>{{$index+1}}.</td>
                                    <td>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                    </td>
                                    <td>
                                        {{$research->code}}-{{$research->id}} | type-id: {{$research->type_id}}
                                        <br>
                                        {{$research->title}}
                                        
                                    </td>
                                    <td>
                                        <b>{{$research->milestone->code}}</b>
                                        <br>
                                        @if($research->renewal)
                                            {{$research->renewal->message}}
                                        @else
                                        {{$research->milestone_id}}-{{$research->milestone->phase}}
                                        @endif
                                        </td>
                                    <td class="text-right">
                                        <x-adminlte-button   wire:click="created({{$research->id}})" 
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="Created"/>
                                        <x-adminlte-button   wire:click="submitted({{$research->id}})" 
                                                theme="warning" icon="fa fa-xs fa-eye" class="btn btn-xs" label="Submitted"/>
                                        <x-adminlte-button   wire:click="review({{$research->id}})" 
                                                theme="info" icon="fa fa-xs fa-eye" class="btn btn-xs" label="Review"/>
                                        <x-adminlte-button   wire:click="delete({{$research->id}})" 
                                                theme="danger" icon="fa fa-xs fa-eye" class="btn btn-xs" label="Delete"/>
                                    </td>
                                </tr>    
                           @endforeach
                        </tbody>
                    </table>
                    {{$researchs->links()}}
                </div>
            @else
                No data
            @endif      
        </div>
    </div>
</div>
