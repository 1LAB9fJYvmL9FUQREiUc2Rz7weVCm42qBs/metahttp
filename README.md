# metahttp
A layer above Linux tools that deal with the HTTP(S) protocol

Installation<br/>
- Install docker<br/>
- Clone this repository<br/>
- Build the docker image from the Dockerfile<br/>
- Run a container from the image<br/>
- As a sanity check, see if your localhost now exposes ports 50774/tcp and 50774/udp:<br/>
<br/>
Metahttp usage:<br/>
- metahttp.xml files:<br/>
- As a first simple example we create a *GET* request against _http://www.eff.org_:<br/>
<br/>
- As a first example for a *POST* request we chose the search platform _duckduckgo.com_, as it allows for a straightforward search without a lot of background noise:<br/>
meta/duckduckgo.metahttp.xml:<br/>
    <session newcookies="true" baseurl="https://duckduckgo.com" proxy="http://127.0.0.1:8080" stdout="-">  
        <req tool="curl" protocol="http/1.1" verbose="false" useproxy="true">  
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>  
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>  
            <header name="Accept-Language" value="en-US,en;q=0.5"/>  
            <header name="Accept-Encoding" value="gzip, deflate"/>  
            <header name="Referer" value="https://duckduckgo.com/"/>  
            <header name="Connection" value="close"/>  
            <header name="Pragma" value="no-cache"/>  
            <header name="Cache-Control" value="no-cache"/>  
            <form method="POST" action="/html" enctype="application/x-www-form-urlencoded">  
                <input name="q" value="black vyper"/>  
            </form>  
        </req>  
    </session>  
- Now, in order to _compile_ this meta data to a bash script, run the following command (requires _nc_ or _ncat_ on your system, _telnet_ will do too):<br/>
`cat meta/duckduckgo.metahttp.xml | nc localhost 50774 >duckduckgo.sh`<br/>
This will result in the following bash script which you can make executable by issuing `chmod +x duckduckgo.sh`:<br/>
`#!/bin/bash \
rm -f cookies.txt; touch cookies.txt \
echo ------------------------------------------------------------ curl POST 'https://duckduckgo.com/html' : \
curl \\  
--proxy http://127.0.0.1:8080 \\  
--include \\  
--request POST \\  
--http1.1 \\  
--header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \\  
--header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \\  
--header 'Accept-Language: en-US,en;q=0.5' \\  
--header 'Accept-Encoding: gzip, deflate' \\  
--header 'Referer: https://duckduckgo.com/' \\  
--header 'Connection: close' \\  
--header 'Pragma: no-cache' \\  
--header 'Cache-Control: no-cache' \\  
--cookie cookies.txt \\  
--cookie-jar cookies.txt \\  
--ssl-no-revoke --insecure \\  
--header 'Host: duckduckgo.com' \\  
--header 'Content-Type: application/x-www-form-urlencoded' \\  
--data-binary $'q=black+vyper' \\  
$'https://duckduckgo.com/html' \\  
  
`

