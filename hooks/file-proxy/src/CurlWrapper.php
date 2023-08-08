<?php

namespace FileProxy;

use Symfony\Component\HttpFoundation\Response;

class CurlWrapper
{
    const USER_AGENT = 'fabernovel-code/media-proxy';
    private $requestHeaders = [];
    private $options = [];
    private $response;

    public function __construct($requestHeaders = [], $options = [])
    {
        if (count($requestHeaders) > 0 && is_array($requestHeaders)) {
            $this->requestHeaders   = $requestHeaders;
            $this->requestHeaders[] = "User-Agent: " . self::USER_AGENT;
        } else {
            $this->requestHeaders = ["User-Agent: " . self::USER_AGENT];
        }
        if (count($options) > 0 && is_array($options)) {
            $this->options = $options;
        }
    }

    public function doGet($url, $queryString = null)
    {
        $s = curl_init();
        curl_setopt($s, CURLOPT_URL, is_null($queryString) ? $url : $url . '?' . $queryString);
        return $this->doMethod($s);
    }

    public function doPost($url, $queryString = null)
    {
        $s = curl_init();
        curl_setopt($s, CURLOPT_URL, $url);
        curl_setopt($s, CURLOPT_POST, true);
        if (!is_null($queryString)) {
            curl_setopt($s, CURLOPT_POSTFIELDS, parse_str($queryString));
        }
        return $this->doMethod($s);
    }

    public function doPut($url, $queryString = null)
    {
        $s = curl_init();
        curl_setopt($s, CURLOPT_URL, $url);
        curl_setopt($s, CURLOPT_CUSTOMREQUEST, 'PUT');
        if (!is_null($queryString)) {
            curl_setopt($s, CURLOPT_POSTFIELDS, parse_str($queryString));
        }
        return $this->doMethod($s);
    }

    public function doDelete($url, $queryString = null)
    {
        $s = curl_init();
        curl_setopt($s, CURLOPT_URL, is_null($queryString) ? $url : $url . '?' . $queryString);
        curl_setopt($s, CURLOPT_CUSTOMREQUEST, 'DELETE');
        if (!is_null($queryString)) {
            curl_setopt($s, CURLOPT_POSTFIELDS, parse_str($queryString));
        }
        return $this->doMethod($s);
    }

    private function doMethod($s)
    {
        curl_setopt($s, CURLOPT_HTTPHEADER, $this->requestHeaders);
        curl_setopt($s, CURLOPT_HEADER, true);
        curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
        foreach ($this->options as $option => $value) {
            curl_setopt($s, $option, $value);
        }
        $out                   = curl_exec($s);

        $status          = curl_getinfo($s, CURLINFO_HTTP_CODE);
        $headers = curl_getinfo($s, CURLINFO_HEADER_OUT);
        curl_close($s);

        list($headers, $content) = $this->decodeOut($out);

        $this->response = new Response($content, $status, $headers);
    }

    private function decodeOut($out)
    {
        // It should be a fancy way to do that :(
        $headersFinished = false;
        $headers         = $content = [];
        $data            = explode("\n", $out);
        foreach ($data as $line) {
            if (trim($line) == '') {
                $headersFinished = true;
            } else {
                if ($headersFinished === false && strpos($line, ':') > 0) {
                    $headers[] = $line;
                }
                if ($headersFinished) {
                    $content[] = $line;
                }
            }
        }
        return [$headers, implode("\n", $content)];
    }

    public function getResponse()
    {
        return $this->response;
    }
}
