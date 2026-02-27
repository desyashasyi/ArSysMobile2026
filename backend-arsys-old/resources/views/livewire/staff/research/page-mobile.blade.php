{{--<div class="row d-block d-sm-none">--}}
<div>
    <div class="row d-block d-sm-none">
        <div class="col-md-12">
            @if($researchs->isNotEmpty())
                <div class="table-responsive users-table">
                    <table class="table table-sm data-table">
                        <thead class="thead">
                            <tr>
                                <th colspan="2" class="text-center" width="100%">Student Research</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($researchs as $index => $research)
                                @if($index%2 == 0)
                                    <tr class="bg-light">
                                @else
                                    <tr>
                                @endif
                                    <td width="5%">{{$index+1}}. </td>
                                    <td>
                                        {{$research->student->program->code}}.{{$research->student->number}}
                                        <br>
                                        {{$research->student->first_name}}
                                        {{$research->student->last_name}}
                                        <div class="text-right row">
                                            <div class="text-right col-md-12">
                                                @if (!$expandViewIndex[$index])
                                                    <x-adminlte-button
                                                        wire:click="expandView({{ $index }}, {{ $research->id }})"
                                                        theme="success" icon="fa fa-xs fa-eye" class="btn btn-xs"
                                                        label="View" />
                                                @endif
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                @if($expandViewIndex[$index])
                                <tr>
                                    <td></td>
                                    <td>
                                        <div x-data="{viewResearch : @entangle('viewResearch') }">
                                            <div x-show="viewResearch">
                                                <livewire:staff.research.view-mobile :wire:key="'$research->id'">
                                            </div>
                                        </div>
                                    </td>
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
