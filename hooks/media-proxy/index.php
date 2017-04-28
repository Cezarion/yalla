<?php

require_once __DIR__ . '/vendor/autoload.php';

use MediaProxy\CurlWrapper;
use MediaProxy\MediaProxy;


// Example for additional Curl request headers and additional curl options for all requests
// $requestHeaders = [
//     'Content-Type:application/json',
//     'Authorization: Basic ' . base64_encode("username:password")
// ];
$requestHeaders = [];
$curlOptions    = [
    CURLOPT_SSL_VERIFYPEER => 0,
    CURLOPT_SSL_VERIFYHOST => 0
];
$proxy = new MediaProxy(new CurlWrapper($requestHeaders, $curlOptions), 'https://www.sharedconvictions.com/');
$proxy->run();
