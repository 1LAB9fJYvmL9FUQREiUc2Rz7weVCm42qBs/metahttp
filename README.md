# metahttp
A layer above Linux tools that deal with the HTTP(S) protocol

## Installation
- Install docker:<br/>
  `sudo apt install docker`<br>
- Clone this repository:<br/>
  `git clone git@github.com:1LAB9fJYvmL9FUQREiUc2Rz7weVCm42qBs/metahttp.git`<br/>
- With `dockerd` running, build the docker image from the _Dockerfile_:<br/>
  `cd metahttp; docker build -t "ubuntu1604/socat/metahttp".`<br/>
- Run a container based on the image:<br/>
  `docker run --name=ubuntu1604-socat-metahttp --detach -it -p 127.0.0.1:50774:50774/tcp -p 127.0.0.1:50774:50774/udp ubuntu1604/socat/metahttp`
- As a sanity check, see if your localhost now exposes ports 50774/tcp and 50774/udp:<br/>
`netstat -antup | grep 50774`<br/>

    tcp        0      0 127.0.0.1:50774         0.0.0.0:*               LISTEN      588215/docker-proxy  
    udp        0      0 127.0.0.1:50774         0.0.0.0:*                           588238/docker-proxy  

## Metahttp usage
### metahttp.xml files
The _metahttp.xml_ files are the basis of an HTTP session. Requests are _derived_ from the metadata contained.<br/>
### GET request example
As a first simple example we create a _GET_ request against _http://www.eff.org_ <br/>
<br/>
meta/eff.org.metahttp.xml:  

    <session newcookies="true" baseurl="https://www.eff.org" stdout="-">
      <req tool="wget" verbose="false">
        <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
        <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
        <form method="GET" action="/" enctype="application/x-www-form-urlencoded"/>
      </req>
    </session>

Now, in order to _compile_ this meta data to bash instructions, run the following command (requires _nc_ or _ncat_ or _socat_ on your system, _telnet_ will do too):<br/>
`cat meta/eff.org.metahttp.xml | nc localhost 50774`  
which will generate the following output:  

    #!/bin/bash
    rm -f cookies.txt; touch cookies.txt
    echo ------------------------------------------------------------ wget GET 'https://www.eff.org/' : 
    wget \
    --server-response \
    --output-document - 2>&1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --load-cookies cookies.txt \
    --save-cookies cookies.txt --keep-session-cookies \
    --no-check-certificate \
    --header 'Host: www.eff.org' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    $'https://www.eff.org/' \
    
<br/>
For now, we just copy and paste the wget command and its arguments (the 11 lines following wget (including the last empty line)) in order to kick off the HTTP request:

    wget \
    --server-response \
    --output-document - 2>&1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --load-cookies cookies.txt \
    --save-cookies cookies.txt --keep-session-cookies \
    --no-check-certificate \
    --header 'Host: www.eff.org' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    $'https://www.eff.org/' \
    

... and we receive the HTTP response, similar to the following:<br/>
<sub>--2020-05-22 15:13:33--  https://www.eff.org/  
Resolving www.eff.org (www.eff.org)... 151.101.112.201, 2a04:4e42:1b::201  
Connecting to www.eff.org (www.eff.org)|151.101.112.201|:443... connected.  
HTTP request sent, awaiting response...  
  HTTP/1.1 200 OK  
  Connection: keep-alive  
  Content-Length: 55046  
  Server: nginx  
  Content-Type: text/html; charset=utf-8</sub>  
  (_... the whole raw HTTP response following here..._)  


### POST request example
As a first example for a _POST_ request we chose the search platform _duckduckgo.com_, as it allows for a straightforward search without a lot of background noise:<br/>
meta/duckduckgo.metahttp.xml:<br/>

    <session newcookies="true" baseurl="https://duckduckgo.com" stdout="-">
      <req tool="curl" protocol="http/1.1" verbose="false">
        <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
        <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
        <header name="Accept-Language" value="en-US,en;q=0.5"/>
        <header name="Referer" value="https://duckduckgo.com/"/>
        <header name="Connection" value="close"/>
        <header name="Pragma" value="no-cache"/>
        <header name="Cache-Control" value="no-cache"/>
        <form method="POST" action="/html" enctype="application/x-www-form-urlencoded">
            <input name="q" value="wfuzz session" urlencode="false"/>
        </form>
      </req>
    </session>

Again, we _compile_ this metadata, this time redirecting the output to a bash script:<br/>
`cat meta/duckduckgo.metahttp.xml | nc localhost 50774 >duckduckgo.sh`<br/>
This will result in the following file which you can make executable by issuing `chmod +x duckduckgo.sh`:<br/>

    #!/bin/bash
    rm -f cookies.txt; touch cookies.txt
    echo ------------------------------------------------------------ curl POST 'https://duckduckgo.com/html' : 
    curl \
    --include \
    --request POST \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Referer: https://duckduckgo.com/' \
    --header 'Connection: close' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --header 'Host: duckduckgo.com' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'q=wfuzz session' \
    $'https://duckduckgo.com/html' \
    
Again, when you run the bash script, you will see the complete HTTP response in your terminal.<br/>

### Proxied Requests
As pen testers, we like to use a proxy in order to position ourselves as MITM (man in the middle). This helps us analyze/repeat/modify requests in detail.<br/>
Our next request (_duckduckgo.proxy.metahttp.xml_) will utilize a Burpsuite proxy on localhost port 8080:<br/>

    <session newcookies="true" baseurl="https://duckduckgo.com" proxy="http://127.0.0.1:8080" stdout="-">
      <req tool="curl" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
        <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
        <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
        <header name="Accept-Language" value="en-US,en;q=0.5"/>
        <header name="Accept-Encoding" value="gzip, deflate"/>
        <header name="Referer" value="https://duckduckgo.com/"/>
        <header name="Connection" value="close"/>
        <header name="Pragma" value="no-cache"/>
        <header name="Cache-Control" value="no-cache"/>
        <form method="POST" action="/html" enctype="application/x-www-form-urlencoded">
            <input name="q" value="wfuzz session"/>
        </form>
      </req>
    </session>

We transform the XML and save the output to file duckduckgo.proxy.sh<br/>
`cat meta/duckduckgo.proxy.metahttp.xml | nc localhost 50774 >duckduckgo.proxy.sh`<br/>
The contents of _duckduckgo.proxy.sh_ are:<br/>

    #!/bin/bash
    rm -f cookies.txt; touch cookies.txt
    echo ------------------------------------------------------------ curl POST 'https://duckduckgo.com/html' : 
    curl \
    --proxy http://127.0.0.1:8080 \
    --include \
    --request POST \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Accept-Encoding: gzip, deflate' \
    --header 'Referer: https://duckduckgo.com/' \
    --header 'Connection: close' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --ssl-no-revoke --insecure \
    --header 'Host: duckduckgo.com' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'q=wfuzz%20session' \
    $'https://duckduckgo.com/html' \


<sup>Note: Why do we explicitly tell this request to be _insecure_?<br/>
    Under normal circumstances, we'd always want a TLS request to be as secure as possible. However, we're in a completely different _context_ here: We've put a proxy between us and the HTTPS server, in order to act as MITM. That means that we explicitly chose an insecure setup, with the proxy exchanging the actual target site certificate with its own (Portswigger) one.</sup><br/>
We make the file executable and run it: `chmod +x duckduckgo.proxy.sh && ./duckduckgo.proxy.sh`<br/>
... which results in the output of the HTTP response - not only in our terminal, but also in Burpsuite proxy.<br/>
We can even conveniently view the rendered web page on the proxy's response tab:<br/>
![BurpSuite Proxy](/images/burp-proxy-rendered-response1.png)
<br/>
<br>
Once you have made yourself familiar with _metahttp_, please keep reading [ADVANCED.md](./ADVANCED.md)<br/>

