@props(['options' => []])

@php

    $options = array_merge([
                    'clear' => true,
                    'dateFormat' => 'Y-m-d H:i',
                    'enableTime' => true,
                    'defaultDate' => 'today',
                    'defaultTime' => 'now',
                    'altFormat' =>  'j F Y',
                    'altInput' => true,
                    'locale' => 'id',

                    ], $options);
@endphp

<div wire:ignore>
    <input
        x-data
        x-init="flatpickr($refs.input, {{json_encode((object)$options)}});"
        x-ref="input"
        type="text"
        {{ $attributes->merge(['class' => 'form-input w-full rounded-md shadow-sm']) }}
        
    />
</div>
