<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you can configure the settings for Cross-Origin Resource Sharing
    | or "CORS". This determines which cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => [], // Set to empty array

    'allowed_origins_patterns' => ['/^http:\/\/localhost:\d+$/', '/^http:\/\/127\.0\.0\.1:\d+$/'], // Allow http://localhost:ANY_PORT

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];
