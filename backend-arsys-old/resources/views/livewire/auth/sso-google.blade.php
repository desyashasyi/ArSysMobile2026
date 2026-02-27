@section('content')

@extends('adminlte::auth.auth-page')
@section('auth_header', __('email@upi.edu registration'))
@section('auth_body')
    <div class="row">
        <div class="col-md-12">
            <x-adminlte-input type="email" wire:model="email" name="ifLabel" label="Email"
                placeholder="Please provide @upi.edu email" />
            <x-adminlte-input wire:model="sso" name="ifLabel" label="SSO UPI"
                placeholder="SSO-UPI" />
        </div>
    </div>
    <div class="row">
        <div class="col-md-4">
            <x-adminlte-button wire:click="save" icon="fa fa-save" class="btn btn-sm" name="quota" theme="success" label="Save" i/>
        </div>
    </div>
@stop

@endsection
