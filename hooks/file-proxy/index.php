<?php

require_once __DIR__ . '/vendor/autoload.php';

use FileProxy\CurlWrapper;
use FileProxy\FileProxy;


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
$proxy = new FileProxy(new CurlWrapper($requestHeaders, $curlOptions));
$proxy->run();
