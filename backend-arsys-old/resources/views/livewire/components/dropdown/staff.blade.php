<div>
    
    <div class="row">
        <div class="col-md-6" wire:ignore>
            <x-adminlte-select2 label="Label" style="width: 100%" id="staff" name="prog">
                <option>Please select your supervisor</option>
                @foreach ($staffs as $index => $staff)
                    <option value="{{$staff->data->id}}">{{$staff->data->first_name}} {{$staff->data->last_name}} {{$staff->data->front_title}}, {{$staff->data->rear_title}}</option>
                @endforeach
            </x-adminlte-select2>
        </div>
    </div>    

</div>
