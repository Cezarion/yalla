<?php

namespace MediaProxy;

use Symfony\Component\HttpFoundation\Request;

/**
 * Retrieve a distant file according to the current request.
 * The distant URL is queried according to the given host (seee constructor)
 * and the current request parameter f (see run() method).
 * @see https://github.com/gonzalo123/rest-proxy [Inspiration library]
 *
 * @author Bastien Gatellier <bastien.gatellier@fabernovel.com>
 */
class MediaProxy
{
    const GET = "GET";
    const POST = "POST";
    const DELETE = "DELETE";
    const PUT = "PUT";
    const OPTIONS = "OPTIONS";
    
    private $distantHost;
    private $request;
    private $curl;
    private $actions = [
        self::GET     => 'doGet',
        self::POST    => 'doPost',
        self::DELETE  => 'doDelete',
        self::PUT     => 'doPut',
        self::OPTIONS => 'doOptions',
    ];

    /**
     * Create a Request object from the global variables and set configurations
     * @param CurlWrapper $curl
     * @param string      $distantHost   Example: https://i-love-poney.com/
     */
    public function __construct(CurlWrapper $curl, $distantHost)
    {
        $this->request = Request::createFromGlobals();
        $this->curl = $curl;
        $this->distantHost = $distantHost;
    }
    
    /**
     * Do the distant request and send the response (echo headers and content)
     */
    public function run()
    {
        $response = $this->dispatch($this->distantHost . $this->request->query->get('f'));
        $response->send();
    }

    /**
     *
     * @param  string    $url
     * @return Response
     */
    private function dispatch($url)
    {
        $action        = $this->getActionName($this->request->getMethod());
        $this->content = $this->curl->$action($url);

        return $this->curl->getResponse();
    }

    /**
     *
     * @param  string  $requestMethod GET, POST…
     * @return string
     */
    private function getActionName($requestMethod)
    {
        if (!array_key_exists($requestMethod, $this->actions)) {
            throw \Exception("Method not allowed");
        }

        return $this->actions[$requestMethod];
    }
}
