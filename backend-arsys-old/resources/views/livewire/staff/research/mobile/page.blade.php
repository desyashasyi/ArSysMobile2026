<div>
    <div class="row">
        <div class="col-md-4">
            <input wire:model="search" type="text" class="my-1 form-control" placeholder="Search student">
        </div>
        <div class="my-2 col-md-8">
            @foreach ($researchTypes as $type)
                <span class="badge bg-{{$type->base->color}}">{{$type->base->code}}-{{$type->base->description}}</span>
            @endforeach
            <span class="badge bg-red">Approval request</span>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td  class="bg-{{$research->type->base->color}} 1%"></td>
                                        @if(
                                            ($research->predefenseApproved->count() != $research->predefenseApproval()->count())
                                            ||
                                            ($research->finaldefenseApproved->count() != $research->finaldefenseApproval()->count())
                                            ||
                                            ($research->seminarApproved->count() != $research->seminarApproval()->count())
                                        )

                                        <td class="bg-red"></td>
                                    @else
                                        <td></td>
                                    @endif
                                    <td>
                                        {{$research->student->first_name}} {{$research->student->last_name}}
                                        <br/>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                        <hr/>
                                        @if($research->milestone)
                                            <b>{{$research->milestone->code}}</b>
                                        @endif
                                        <br/>
                                        @if($research->renewal)
                                            {{$research->renewal->message}}
                                        @else
                                            @if($research->milestone)
                                                {{$research->milestone->phase}}
                                            @endif
                                        @endif
                                    </td>

                                    <td class="text-right">
                                        @if(!$expandViewIndex[$index])
                                            <x-adminlte-button   wire:click="expandView({{$index}}, {{$research->id}})"
                                                theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs" label="View"/>
                                        @endif
                                    </td>
                                    <td></td>
                                </tr>
                                @if($expandViewIndex[$index])
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td colspan="2">
                                            <div x-data="{viewResearch : @entangle('viewResearch') }">
                                                <div x-show="viewResearch">
                                                    <livewire:staff.research.view :researchId="$research->id" :wire:key="'view-'.$research->id" />
                                                </div>
                                            </div>
                                        </td>
                                        <td></td>
                                    </tr>
                                @endif
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
