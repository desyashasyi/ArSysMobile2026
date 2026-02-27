<div>
    @section('plugins.Select2', true)
    <div wire:ignore>
        <x-adminlte-select2 data-select2-id="dataProgram" id="program" name="data-select2-id" >
            <option value="0">Please select your program of study</option>
            @foreach ($programs as $index => $program)
                <option value="{{$program->id}}">{{++$index}}. {{$program->name}}</option>
            @endforeach
        </x-adminlte-select2>
    </div>  


    @push('scripts')
        <script>
            var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function () {
                $('#program').on('change', function (e) {
                    console.log($(this).select2('data'));
                    var dataProgram = $('#program').select2("val");
                    //let data = $(this).val();
                    @this.set('program', dataProgram);
                    window.livewire.emit('selectProgram', { program : dataProgram });
                });

            });
        </script>
    @endpush
</div>