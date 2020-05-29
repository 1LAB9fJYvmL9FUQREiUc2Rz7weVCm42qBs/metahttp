# Sessions
There is more about __*metahttp*__ than single requests. It becomes much more interesting when we're dealing with HTTP _sessions_ and simulate browser behaviour.<br/>
Essential to HTTP sessions are the _session cookies_. We will talk about those in the following example:<br/>
_Hackthebox.eu_ hosts labs that contain machines that are supposed to be _hacked_. It is a playground for pentesters and the like to sharpen their skills - without having to worry about legal implications.<br/>
The sign-up process of hackthebox is a hacking challenge by itself - you will have to hack your way to the registration page.<br/>
The following example might contain spoilers - so stop reading if you intend to master the challenge on your own!<br/>

The session that we are going to introduce here consists of 3 requests.<br/>
Here is the content of _meta/hackthebox.metahttp.xml_:<br/>

    <session newcookies="true" baseurl="https://www.hackthebox.eu" proxy="http://127.0.0.1:8080" stdout="-">
        <req tool="curl" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <form method="GET" action="/invite" enctype="application/x-www-form-urlencoded"/>
        </req>
        <req tool="curl" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Referer" value="https://www.hackthebox.eu/"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <form method="POST" action="/api/invite/generate" enctype="application/x-www-form-urlencoded">
            </form>
        </req>
        <req tool="curl" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Accept-Encoding" value="gzip, deflate"/>
            <header name="Referer" value="https://www.hackthebox.eu/"/>
            <header name="Connection" value="close"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <form method="POST" action="/invite" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="_token" value="I_DO_NOT_KNOW_YET"/> 
                <input title="Please enter your invite code" value="I_DO_NOT_KNOW_YET" name="code"/> 
            </form>
        </req>
    </session>

We give it a shot with `cat meta/hackthebox.metahttp.xml | nc localhost 50774`<br/>

    #!/bin/bash
    rm -f cookies.txt; touch cookies.txt
    echo ------------------------------------------------------------ curl GET 'https://www.hackthebox.eu/invite' : 
    curl \
    --proxy http://127.0.0.1:8080 \
    --include \
    --request GET \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --ssl-no-revoke --insecure \
    --header 'Host: www.hackthebox.eu' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    $'https://www.hackthebox.eu/invite' \
    
    echo ------------------------------------------------------- curl POST 'https://www.hackthebox.eu/api/invite/generate' : 
    curl \
    --proxy http://127.0.0.1:8080 \
    --include \
    --request POST \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Referer: https://www.hackthebox.eu/' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --ssl-no-revoke --insecure \
    --header 'Host: www.hackthebox.eu' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'' \
    $'https://www.hackthebox.eu/api/invite/generate' \
    
    echo ------------------------------------------------------------ curl POST 'https://www.hackthebox.eu/invite' : 
    curl \
    --proxy http://127.0.0.1:8080 \
    --include \
    --request POST \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Accept-Encoding: gzip, deflate' \
    --header 'Referer: https://www.hackthebox.eu/' \
    --header 'Connection: close' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --ssl-no-revoke --insecure \
    --header 'Host: www.hackthebox.eu' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'_token=I_DO_NOT_KNOW_YET&code=I_DO_NOT_KNOW_YET' \
    $'https://www.hackthebox.eu/invite' \

## 1st request<br/>
Let's copy and paste the first request and see what it returns:<br/>

    root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# rm -f cookies.txt; touch cookies.txt
    root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# echo ------------------------------------------------------------ curl GET 'https://www.hackthebox.eu/invite' : 
    ------------------------------------------------------------ curl GET https://www.hackthebox.eu/invite :
    root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# curl \
    > --proxy http://127.0.0.1:8080 \
    > --include \
    > --request GET \
    > --http1.1 \
    > --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > --header 'Accept-Language: en-US,en;q=0.5' \
    > --header 'Pragma: no-cache' \
    > --header 'Cache-Control: no-cache' \
    > --cookie cookies.txt \
    > --cookie-jar cookies.txt \
    > --ssl-no-revoke --insecure \
    > --header 'Host: www.hackthebox.eu' \
    > --header 'Content-Type: application/x-www-form-urlencoded' \
    > $'https://www.hackthebox.eu/invite' \
    > 
    HTTP/1.0 200 Connection established
    
    HTTP/1.1 200 OK
    Date: Thu, 28 May 2020 17:36:22 GMT
    Content-Type: text/html; charset=UTF-8
    Connection: close
    Set-Cookie: __cfduid=d6846f9586833399b55b6549aa7f41f4b1590688617; expires=Sat, 27-Jun-20 17:56:57 GMT; path=/; domain=.hackthebox.eu; HttpOnly; SameSite=Lax; Secure
    Vary: Accept-Encoding
    Cache-Control: no-cache, private
    Set-Cookie: XSRF-TOKEN=eyJpdiI6IjJ6VjdwOVhJM0V1TjZpM1wvdk16MFp3PT0iLCJ2YWx1ZSI6ImtrNnZJN2xRZENsRFV6Y3EyNEc4cVp0WDZTbW5TblI0VGhTMmVqVmlhOW1JaHhzUnFIRHhJU21xRzl6OXN2THkiLCJtYWMiOiJjNzhjNjA0MWM1MDJmNjE4ZTkyMjE2ZmE2NWI3OTgwMmY3MzU0ZTE3MTUzMjVmOTEwOTVlZTc5ZjZkMjhmZTc3In0%3D; expires=Thu, 28-May-2020 19:56:57 GMT; Max-Age=7200; path=/; secure
    X-Frame-Options: SAMEORIGIN
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    set-cookie: hackthebox_session=eyJpdiI6InJVMFBtRzdBb1lsSWhQdFZPckVpYUE9PSIsInZhbHVlIjoiODdIbHpNcVwvMWNGNjJ6c1lNbHVxZUYyYlNsXC84K2JDcUpwNEx2eU1rRENXOFwvNWRlb1Z0WjdXNFBONHZ6N1l4ZCIsIm1hYyI6IjEzOTMwZDMzZTk0OWEyYTk4OTQyNTE1MzA1MGVkYWZiNGI2MDdiNzVlODY4MTk2NTNkMTcwYmY3MjI2NzUxZjkifQ%3D%3D; expires=Thu, 28-May-2020 19:56:57 GMT; Max-Age=7200; path=/; secure; httponly
    CF-Cache-Status: DYNAMIC
    cf-request-id: 02fe072db30000d12104344200000001
    Expect-CT: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
    Strict-Transport-Security: max-age=0; includeSubDomains
    Server: cloudflare
    CF-RAY: 59a9daf5ecdad121-TXL
    Content-Length: 7440

    <!DOCTYPE html> <html lang="en"> <head> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1"> <meta name="description" content="Entry challenge for joining Hack The Box. You have to hack your way in!" /> <meta name="keywords" content="pen testing,hack,hacking,penetration testing,infosec,information security,labs"> <meta name="author" content="Hack The Box"> <meta name="google-site-verification" content="ut2KvZ-Bku4Vdbk1hfkkiX6W_Gb_9-CR9UD8ZU4B0mU" /> <meta property="og:title" content="Can you hack this box?" /> <meta property="og:url" content="https://www.hackthebox.eu" /> <meta property="og:image" content="https://www.hackthebox.eu/images/favicon.png" /> <meta property="og:site_name" content="Hack The Box" /> <meta property="fb:app_id" content="269224263502219" /> <meta property="og:description" content="An online platform to test and advance your skills in penetration testing and cyber security." /> <meta name="csrf-token" content="skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB"> <meta name="wot-verification" content="1eeefbec1f6305acd476" /> <script type='application/ld+json'> { "@context": "http://schema.org", "@type": "Organization", "url": "https://www.hackthebox.eu", "name": "Hack The Box", "contactPoint": [{ "@type": "ContactPoint", "telephone": "+44-203-6178-265", "contactType": "emergency" }], "sameAs": [ "https://www.facebook.com/hackthebox.eu", "https://www.linkedin.com/company/hackthebox", "https://twitter.com/hackthebox_eu" ], "logo": "https://www.hackthebox.eu/images/favicon.png", "description": "An online platform to test and advance your skills in penetration testing and cyber security.", "founder": { "@type": "Person", "name": "Haris Pylarinos" }, "aggregateRating": { "@type": "AggregateRating", "ratingValue": "4.95", "bestRating": "5", "worstRating": "1", "ratingCount": "787" } } </script> <script> !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0"; analytics.load("0TfpkI8Z8dM5cArXmzVpfEBmj10vpbfI"); analytics.page("Invite"); }}(); </script> <title>Hack The Box :: Can you hack this box?</title> <link rel="canonical" href="https://www.hackthebox.eu/invite" /> <style> .native-ad #_default_ { position: relative; padding: 10px 10px; background: repeating-linear-gradient(-45deg, transparent, transparent 5px, hsla(0, 0%, 0%, .05) 5px, hsla(0, 0%, 0%, .05) 10px) hsla(203, 11%, 23%, 0.5); font-size: 14px; line-height: 1.5; } .native-ad #_default_:after { position: absolute; bottom: 0; left: 0; overflow: hidden; width: 100%; border-bottom: solid 4px #9acc15; content: ""; transition: all .2s ease-in-out; transform: scaleX(0); } .native-ad #_default_:hover:after { transform: scaleX(1); } .native-ad .default-ad { display: none; } .native-ad ._default_ { display: inline; overflow: hidden; } .native-ad ._default_ > * { vertical-align: middle; } .native-ad a { color: inherit; text-decoration: none; } .native-ad a:hover { color: inherit; } .native-ad .default-image { display: none; } .native-ad .default-title, .native-ad .default-description { display: inline; line-height: 1; } .native-ad .default-title { position: relative; margin-right: 8px; font-weight: 600; } .native-ad .default-title:before { position: absolute; top: -23px; padding: 4px 6px; border-radius: 3px; background-color: #9acc15; color: #fff; content: "Sponsor"; text-transform: uppercase; font-weight: 600; letter-spacing: 1px; font-size: 10px; line-height: 1; } </style> <link rel="stylesheet" href="https://www.hackthebox.eu/css/htb-frontend.css" /> <link rel="stylesheet" href="https://www.hackthebox.eu/css/icons.css" /> <link rel="icon" href="/images/favicon.png"> <script async src="https://www.googletagmanager.com/gtag/js?id=AW-757546894"></script> <script> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'AW-757546894'); </script> </head> <body class="blank" style="overflow-y:hidden; "> <script> (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){ (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o), m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m) })(window,document,'script','https://www.google-analytics.com/analytics.js','ga'); ga('create', 'UA-93577176-1', 'auto'); ga('set','anonymizeIp',true); ga('send', 'pageview'); </script> <div class="wrapper"> <section class="content" style="margin:0px; padding:0px;"> <div class="container-center centerbox"> <div class="view-header"> <div class="header-icon"> <i class="pe page-header-icon pe-7s-smile"></i> </div> <div class="header-title"> <h1 style="font-size:24px;margin-bottom:2px;">Invite Challenge</h1> <small> Hi! Feel free to hack your way in :) </small> </div> </div> <div class="panel panel-filled"> <div class="panel-body"> <p><span class="c-white">Hack this page to get your invite code!</span></p> <form action="https://www.hackthebox.eu/invite" id="verifyForm" method="post"> <input type="hidden" name="_token" value="skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB"> <div class="form-group "> <label class="control-label" for="code">Invite Code</label> <input type="text" title="Please enter your invite code" required="" value="" name="code" id="code" class="form-control"> <span class="help-block small"></span> </div> <div> <button class="btn btn-accent">Sign Up</button> </div> </form> </div> </div> <span class="help-block small text-center">If you are already a member click <a href="https://www.hackthebox.eu/login">here</a> to login.</span> <br> <div class="view-header"> <div class="header-icon"> <i class="pe page-header-icon pe-7s-way"></i> </div> <div class="header-title"> <h3> Want some help? </h3> <br> <div style="display: inline-block"> <button class="btn btn-accent" onclick="showHint()"> Click Here! </button> <p id="help_text" hidden><br> You could check the console... </p> </div> </div> </div> <div class="native-ad"></div> <script> (function(){ if(typeof _bsa !== 'undefined' && _bsa) { _bsa.init('default', 'CKYDLKJJ', 'placement:hacktheboxeu', { target: '.native-ad', align: 'horizontal', disable_css: 'true' }); } })(); </script> </div> <div class="particles_full" id="particles-js"></div> </section> </div> <script src="https://www.hackthebox.eu/js/htb-frontend.min.js"></script> <script defer src="/js/inviteapi.min.js"></script> <script defer src="https://www.hackthebox.eu/js/calm.js"></script> <script>function showHint() { $("#help_text").show(); }</script> </body> </html>root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# 

Pay some attention to the _Set-Cookie_ response headers above.<br/>
## cookies.txt
_curl_ (and _wget_ too) have integrated session management; they are able to write to and read from a cookies file. We are making use of that. Let's check what the _curl_ command created: `cat cookies.txt`<br/>
    
    # Netscape HTTP Cookie File
    # https://curl.haxx.se/docs/http-cookies.html
    # This file was generated by libcurl! Edit at your own risk.
    
    #HttpOnly_www.hackthebox.eu     FALSE   /       TRUE    1590695804      hackthebox_session      eyJpdiI6InJVMFBtRzdBb1lsSWhQdFZPckVpYUE9PSIsInZhbHVlIjoiODdIbHpNcVwvMWNGNjJ6c1lNbHVxZUYyYlNsXC84K2JDcUpwNEx2eU1rRENXOFwvNWRlb1Z0WjdXNFBONHZ6N1l4ZCIsIm1hYyI6IjEzOTMwZDMzZTk0OWEyYTk4OTQyNTE1MzA1MGVkYWZiNGI2MDdiNzVlODY4MTk2NTNkMTcwYmY3MjI2NzUxZjkifQ%3D%3D
    www.hackthebox.eu       FALSE   /       TRUE    1590695804      XSRF-TOKEN      eyJpdiI6IjJ6VjdwOVhJM0V1TjZpM1wvdk16MFp3PT0iLCJ2YWx1ZSI6ImtrNnZJN2xRZENsRFV6Y3EyNEc4cVp0WDZTbW5TblI0VGhTMmVqVmlhOW1JaHhzUnFIRHhJU21xRzl6OXN2THkiLCJtYWMiOiJjNzhjNjA0MWM1MDJmNjE4ZTkyMjE2ZmE2NWI3OTgwMmY3MzU0ZTE3MTUzMjVmOTEwOTVlZTc5ZjZkMjhmZTc3In0%3D
    #HttpOnly_.hackthebox.eu        TRUE    /       TRUE    1593280617      __cfduid        d6846f9586833399b55b6549aa7f41f4b1590688617

One other thing is noteworthy in the response: The invite code submission form contains a hidden field containing a CSRF token:<br/>
`<input type="hidden" name="_token" value="skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB">`<br/>
We will come back to that field later.<br/>
## 2nd request
When we kick off the second request, _curl_ will automatically integrate the session cookies in the request headers:<br/>

    root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# curl \
    > --proxy http://127.0.0.1:8080 \
    > --include \
    > --request POST \
    > --http1.1 \
    > --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > --header 'Accept-Language: en-US,en;q=0.5' \
    > --header 'Referer: https://www.hackthebox.eu/' \
    > --header 'Pragma: no-cache' \
    > --header 'Cache-Control: no-cache' \
    > --cookie cookies.txt \
    > --cookie-jar cookies.txt \
    > --ssl-no-revoke --insecure \
    > --header 'Host: www.hackthebox.eu' \
    > --header 'Content-Type: application/x-www-form-urlencoded' \
    > --data-binary $'' \
    > $'https://www.hackthebox.eu/api/invite/generate' \
    > 
    HTTP/1.0 200 Connection established
    
    HTTP/1.1 200 OK
    Date: Thu, 28 May 2020 17:57:40 GMT
    Content-Type: application/json
    Connection: close
    Vary: Accept-Encoding
    Cache-Control: no-cache, private
    X-Frame-Options: SAMEORIGIN
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    CF-Cache-Status: DYNAMIC
    cf-request-id: 02fe07d1d70000d0fdfd825200000001
    Expect-CT: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
    Strict-Transport-Security: max-age=0; includeSubDomains
    Server: cloudflare
    CF-RAY: 59a9dbfc8d1fd0fd-TXL
    Content-Length: 99

    {"success":1,"data":{"code":"V1ZWRkYtUFFUVUMtUkRQR0UtSVpCVVctTEJEQUM=","format":"encoded"},"0":200}
    

The response indicates that the _code_ is encrypted, so let's decrypt it:<br/>
`echo $(base64 --decode <<<"V1ZWRkYtUFFUVUMtUkRQR0UtSVpCVVctTEJEQUM=")`<br/>

    WVVFF-PQTUC-RDPGE-IZBUW-LBDAC

## 3rd request
With the responses of the first 2 requests, we have gained some information with which we can complete our third request: The CSRF token from the HTML form (see above) and the invitation code. We edit _hackthebox.metahttp.xml_ so that the 3rd request looks like the following. (`tail -n 15 meta/hackthebox.metahttp.xml`)

        <req tool="curl" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Accept-Encoding" value="gzip, deflate"/>
                <header name="Referer" value="https://www.hackthebox.eu/"/>
            <header name="Connection" value="close"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <form method="POST" action="/invite" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="_token" value="skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB"/> 
                <input title="Please enter your invite code" value="WVVFF-PQTUC-RDPGE-IZBUW-LBDAC" name="code"/> 
            </form>
        </req>
    </session>
Let's compile it: `cat meta/hackthebox.metahttp.xml | nc localhost 50774`<br/>

    _(we have truncated the first 2 requests here)_
    echo ------------------------------------------------------------ curl POST 'https://www.hackthebox.eu/invite' : 
    curl \
    --proxy http://127.0.0.1:8080 \
    --include \
    --request POST \
    --http1.1 \
    --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    --header 'Accept-Language: en-US,en;q=0.5' \
    --header 'Accept-Encoding: gzip, deflate' \
    --header 'Referer: https://www.hackthebox.eu/' \
    --header 'Connection: close' \
    --header 'Pragma: no-cache' \
    --header 'Cache-Control: no-cache' \
    --cookie cookies.txt \
    --cookie-jar cookies.txt \
    --ssl-no-revoke --insecure \
    --header 'Host: www.hackthebox.eu' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'_token=skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB&code=WVVFF-PQTUC-RDPGE-IZBUW-LBDAC' \
    $'https://www.hackthebox.eu/invite' \

... and copy and paste it in order to run the command. Remember that again, the session cookies will be integrated in the request:<br/>

    root@kali:~/tools/docker/ubuntu1604-docker/jre/metahttp# curl \
    > --proxy http://127.0.0.1:8080 \
    > --include \
    > --request POST \
    > --http1.1 \
    > --header 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > --header 'Accept-Language: en-US,en;q=0.5' \
    > --header 'Accept-Encoding: gzip, deflate' \
    > --header 'Referer: https://www.hackthebox.eu/' \
    > --header 'Connection: close' \
    > --header 'Pragma: no-cache' \
    > --header 'Cache-Control: no-cache' \
    > --cookie cookies.txt \
    > --cookie-jar cookies.txt \
    > --ssl-no-revoke --insecure \
    > --header 'Host: www.hackthebox.eu' \
    > --header 'Content-Type: application/x-www-form-urlencoded' \
    > --data-binary $'_token=skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB&code=WVVFF-PQTUC-RDPGE-IZBUW-LBDAC' \
    > $'https://www.hackthebox.eu/invite' \
    > 
    HTTP/1.0 200 Connection established
    
    HTTP/1.1 302 Found
    Date: Thu, 28 May 2020 18:00:50 GMT
    Content-Type: text/html; charset=UTF-8
    Connection: close
    Cache-Control: no-cache, private
    Location: https://www.hackthebox.eu/register
    Set-Cookie: XSRF-TOKEN=eyJpdiI6Ijk4bk1EOHdLOXFoU0dsdmxOYVFGRHc9PSIsInZhbHVlIjoiWWhsMFB2bFZ0akxzelZCcm1mNTdxSUJiWjVyZEx6ZnZlZWdFQ0d4cHIwckVUXC9CMlBPNFlpK00wSlE1d2NKQjMiLCJtYWMiOiI0YTY5ZDkwZTc4NTA5MDgxYjRmNzUyNzZkMWRiMDU5Y2M2ZGFiNGY5MDkyNjlmNzJlMjE0ODViNDdjZDc4NTk0In0%3D; expires=Thu, 28-May-2020 20:00:50 GMT; Max-Age=7200; path=/; secure
    X-Frame-Options: SAMEORIGIN
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    set-cookie: hackthebox_session=eyJpdiI6IkNDSWYwQ05GQ3ZPakdFaEw1MzVHekE9PSIsInZhbHVlIjoibWtIaEFXVW1jclhPTzY5RmxmTCtXUDV5YXFzcTNcL3ZLU0J3eVlYYXlhWTZGbFI1ODc0dXJyalhlcTFLWlBZN3AiLCJtYWMiOiI5NDBjYzQ5MjkzOWZkYjg1N2RhN2E5OTk3YTUzNTNmMDJmMWZkOWY2Y2YxN2NkMTgyZWQzMjQ0YzgyYmNmZDlhIn0%3D; expires=Thu, 28-May-2020 20:00:50 GMT; Max-Age=7200; path=/; secure; httponly
    CF-Cache-Status: DYNAMIC
    cf-request-id: 02fe0aba500000d11d4798d200000001
    Expect-CT: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
    Strict-Transport-Security: max-age=0; includeSubDomains
    Server: cloudflare
    CF-RAY: 59a9e0a3bd8fd11d-TXL
    Content-Length: 333

    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8" />
    <meta http-equiv="refresh" content="0;url='https://www.hackthebox.eu/register'" />
    <title>Redirecting to https://www.hackthebox.eu/register</title>
    </head>
    <body>
    Redirecting to <a href="https://www.hackthebox.eu/register">https://www.hackthebox.eu/register</a>.
    </body>
    </html>

You might not notice right away, but the fact that we received a redirect (302) response to the Location _/register_ means that our request succeeded!<br/>
With an invalid request (CSRF token not fitting to the invite code) we would have stayed on the _/invite_ page with a corresponding error message.
