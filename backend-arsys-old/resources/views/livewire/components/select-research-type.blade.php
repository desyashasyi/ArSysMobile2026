<div>
    {{-- Care about people's approval and you will be their prisoner. --}}
    <div class="row">
        <div class="col-md-5">
            <x-adminlte-select2 style="width: 100%" wire:model="researchTypeId"
                id="researchType" name="researchType">
                <option default>Please select research type</option>
                @foreach ($researchTypes as $index => $type)
                    <option value="{{ $type->id }}">{{ $index + 1 }}.
                        <b>{{ $type->data->code }}</b>-{{ $type->data->description }}</option>
                @endforeach
            </x-adminlte-select2>
            @error('programCreate')
                <span class="text-danger">{{ $message }}</span><br>
            @enderror
        </div>
    </div>
    @push('scripts')
        <script>
            //var CSRF_TOKEN = $('meta[name="csrf-token"]').attr('content');
            $(document).ready(function() {
                $('#researchType').on('change', function(e) {
                    let dataResearchType = $(this).val();
                    @this.set('researchTypeId', dataResearchType);
                    //console.log('here');
                    window.livewire.emit('sendResearchType');
                });
                window.livewire.on('reloadSelectResearchType', () => {
                    $('#researchType').select2('destroy');
                    $('#researchType').select2();
                });
            });
        </script>
    @endpush
</div>
