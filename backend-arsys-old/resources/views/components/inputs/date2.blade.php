@props(['options' => []])

@php

    $options = array_merge([
                    'clear' => true,
                    'dateFormat' => 'Y-m-d',
                    'enableTime' => false,
                    'defaultDate' => 'today',
                    //'altFormat' =>  'j F Y',
                    'altInput' => true,
                    //'locale' => 'id',

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
