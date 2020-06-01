# Sessions
There is more about __*metahttp*__ than single requests. It becomes much more interesting when we're dealing with HTTP _sessions_ and simulate browser behaviour.<br/>
Essential to HTTP sessions are the _session cookies_. We will talk about those in the following example:<br/>
_Hackthebox.eu_ hosts labs that contain machines that are supposed to be _hacked_. It is a playground for pentesters and the like to sharpen their skills - without having to worry about legal implications.<br/>
The sign-up process of hackthebox is a hacking challenge by itself - you will have to hack your way to the registration page.<br/>
The following example might contain spoilers - so stop reading if you intend to master the challenge on your own!<br/>

The session that we are going to introduce here consists of 3 requests.<br/>
Here is the content of _meta/hackthebox.metahttp.xml_:<br/>

    <session newcookies="true" baseurl="https://www.hackthebox.eu" proxy="http://127.0.0.1:8080" stdout="-" xmlns="urn:1LAB9fJYvmL9FUQREiUc2Rz7weVCm42qBs">
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

We give it a shot with `cat meta/hackthebox.metahttp.xml | ./metahttp.sh`<br/>

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
One other thing is noteworthy in the response: The invite code submission form contains a hidden field containing a CSRF token:<br/>
`<input type="hidden" name="_token" value="skjfZaE4BcsoIaQNlt1YrmsEDsmWeC9yQwrihVOB">`<br/>
We will come back to that field later.<br/>
### cookies.txt
_curl_ (and _wget_ too) have integrated session management; they are able to write to and read from a cookies file. We are making use of that. Let's check what the _curl_ command created: `cat cookies.txt`<br/>
    
    # Netscape HTTP Cookie File
    # https://curl.haxx.se/docs/http-cookies.html
    # This file was generated by libcurl! Edit at your own risk.
    
    #HttpOnly_www.hackthebox.eu     FALSE   /       TRUE    1590695804      hackthebox_session      eyJpdiI6InJVMFBtRzdBb1lsSWhQdFZPckVpYUE9PSIsInZhbHVlIjoiODdIbHpNcVwvMWNGNjJ6c1lNbHVxZUYyYlNsXC84K2JDcUpwNEx2eU1rRENXOFwvNWRlb1Z0WjdXNFBONHZ6N1l4ZCIsIm1hYyI6IjEzOTMwZDMzZTk0OWEyYTk4OTQyNTE1MzA1MGVkYWZiNGI2MDdiNzVlODY4MTk2NTNkMTcwYmY3MjI2NzUxZjkifQ%3D%3D
    www.hackthebox.eu       FALSE   /       TRUE    1590695804      XSRF-TOKEN      eyJpdiI6IjJ6VjdwOVhJM0V1TjZpM1wvdk16MFp3PT0iLCJ2YWx1ZSI6ImtrNnZJN2xRZENsRFV6Y3EyNEc4cVp0WDZTbW5TblI0VGhTMmVqVmlhOW1JaHhzUnFIRHhJU21xRzl6OXN2THkiLCJtYWMiOiJjNzhjNjA0MWM1MDJmNjE4ZTkyMjE2ZmE2NWI3OTgwMmY3MzU0ZTE3MTUzMjVmOTEwOTVlZTc5ZjZkMjhmZTc3In0%3D
    #HttpOnly_.hackthebox.eu        TRUE    /       TRUE    1593280617      __cfduid        d6846f9586833399b55b6549aa7f41f4b1590688617

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
Let's compile it: `cat meta/hackthebox.metahttp.xml | ./metahttp.sh`<br/>

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
With an invalid request (a request where CSRF token and invite code wouldn't correlate) we would have stayed on the _/invite_ page with a corresponding error message.<br/>
<br/>
# Automated session with __wfuzz__
We are big fans of Xavi Mendez' _wfuzz_. (https://github.com/xmendez/wfuzz)<br/>
That's why _metahttp_ embraces the concepts and lingo of _wfuzz_.<br/>
Let's illustrate that with the following example, which is an automation of the before mentioned _hackthebox_ invite challenge.<br/>
During the course of the _curl_ session, manual work was required in terms of editing the _hackthebox.metahttp.xml_ with the gathered CSRF token and invite code. This manual intervention will not be necessary with the following _metahttp_ session, because we will use _wfuzz_' object introspection functionality.<br/>

## Metadata
Here is the content of our new session file _meta/hackthebox.wfuzz.metahttp.xml_:

    <session newcookies="true" baseurl="https://www.hackthebox.eu" proxy="http://127.0.0.1:8080" stdout="-" xmlns="urn:1LAB9fJYvmL9FUQREiUc2Rz7weVCm42qBs">
        <req tool="wfuzz" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <payload type="list" fn="GET"/>
            <form method="FUZZ" action="/invite" enctype="application/x-www-form-urlencoded"/>
        </req>
        <req tool="wfuzz" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Referer" value="https://www.hackthebox.eu/"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <payload type="wfuzzp" fn="WFUZZP1" description="FUZZ: read results of the 1st request"/>
            <cookie name="__cfduid" value="FUZZ[r.cookies.response.__cfduid]"/>
            <cookie name="hackthebox_session" value="FUZZ[r.cookies.response.hackthebox_session]"/>
            <cookie name="XSRF-TOKEN" value="FUZZ[r.cookies.response.XSRF-TOKEN]"/>
            <form method="POST" action="/api/invite/generate" enctype="application/x-www-form-urlencoded">
            </form>
        </req>
        <req tool="wfuzz" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Accept-Encoding" value="gzip, deflate"/>
            <header name="Referer" value="https://www.hackthebox.eu/"/>
            <header name="Connection" value="close"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <payload type="wfuzzp" fn="WFUZZP1" description="FUZZ: read results of the 1st request"/>
            <cookie name="__cfduid" value="FUZZ[r.cookies.response.__cfduid]"/>
            <cookie name="hackthebox_session" value="FUZZ[r.cookies.response.hackthebox_session]"/>
            <cookie name="XSRF-TOKEN" value="FUZZ[r.cookies.response.XSRF-TOKEN]"/>
            <!--<payload type="wfuzzp" fn="WFUZZP1" field="history.content|gregex('.*name=.csrf-token. content=.([^>]*).>.*')"/>--> 
            <payload type="wfuzzp" fn="WFUZZP1" field="history.content|gregex('.*input [^>]*name=._token. [^>]*value=.([^>]+).>.*')"/> 
            <!-- Note: payload 'decoder' attribute only supported with wfuzzp payload and existing 'field' attribute" --> 
            <payload type="wfuzzp" fn="WFUZZP2" field="history.content|gregex('.*.code.:.([^,]*).,.*')" decoder="base64" description="FUZZ: read results of the 2nd request"/>
            <!--<extraswitch name="- -dry-run" value=""/>-->
            <form method="POST" action="/invite" enctype="application/x-www-form-urlencoded">
                    <input name="_token" value="FUZ2Z"/> 
                    <input name="code" value="FUZ3Z"/> 
            </form>
        </req>
        <req tool="wfuzz" insecure="true" protocol="http/1.1" verbose="false" useproxy="true">
            <header name="User-Agent" value="Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0"/>
            <header name="Accept" value="text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"/>
            <header name="Accept-Language" value="en-US,en;q=0.5"/>
            <header name="Referer" value="https://www.hackthebox.eu/invite"/>
            <header name="Pragma" value="no-cache"/>
            <header name="Cache-Control" value="no-cache"/>
            <payload type="wfuzzp" fn="WFUZZP3" description="FUZZ: read results of the 3rd request"/>
            <cookie name="hackthebox_session" value="FUZZ[r.cookies.response.hackthebox_session]"/>
            <cookie name="XSRF-TOKEN" value="FUZZ[r.cookies.response.XSRF-TOKEN]"/>
            <form method="GET" action="/register" enctype="application/x-www-form-urlencoded">
            </form>
        </req>
    </session>

You might notice that the _tool_ attribute of each request has changed to _wfuzz_. Let's also introduce the concept of _payloads_: Each _payload_ within a request provides a stream of values that substitute a corresponding placeholder (_FUZ?Z_) in that request. The first payload will substitute placeholder FUZZ, the 2nd will substitute placeholder FUZ2Z (and so forth). The result can be one to many substitutions (== requests), each corresponding to a combination of values in the streams.<br/>
Please refer to the _wfuzz_ documentation for a more detailed (or better) description of _wfuzz_.<br/>
Before you get confused or turned off, here's the good news: We will mostly use single-value payloads in this session.<br/>
Things will get clearer once we play around with the _metahttp_ _wfuzz_ session.<br/>

## 1st request     
We compile the metadata: `cat meta/hackthebox.wfuzz.metahttp.xml | ./metahttp.sh`<br/>

    #!/bin/bash
    rm -f WFUZZP?
    echo ------------------------------------------------------------ wfuzz FUZZ 'https://www.hackthebox.eu/invite' : 
    wfuzz \
    -p 127.0.0.1:8080 \
    -c \
    -z 'list,GET' \
    -X FUZZ \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    --oF WFUZZP1 \
    -H 'Host: www.hackthebox.eu' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    $'https://www.hackthebox.eu/invite' \
    
    echo ------------------------------------------------------------ wfuzz POST 'https://www.hackthebox.eu/api/invite/generate' : 
    wfuzz \
    -p 127.0.0.1:8080 \
    -c \
    -z 'wfuzzp,WFUZZP1' \
    -X POST \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Referer: https://www.hackthebox.eu/' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    --oF WFUZZP2 \
    -b '__cfduid=FUZZ[r.cookies.response.__cfduid]; hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    -H 'Host: www.hackthebox.eu' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d $'' \
    $'https://www.hackthebox.eu/api/invite/generate' \
    
    echo ------------------------------------------------------------ wfuzz POST 'https://www.hackthebox.eu/invite' : 
    wfuzz \
    -p 127.0.0.1:8080 \
    -c \
    -z 'wfuzzp,WFUZZP1' \
    -z file,`f=$(mktemp); wfpayload.py -z 'wfuzzp,WFUZZP1' --field "history.content|gregex('.*input [^>]*name=._token. [^>]*value=.([^>]+).>.*')" | grep -vE "^$|^Warning:">$f; echo -n $f` \
    -z file,`f=$(mktemp); wfpayload.py -z 'wfuzzp,WFUZZP2' --field "history.content|gregex('.*.code.:.([^,]*).,.*')" | grep -vE "^$|^Warning:" | base64 --decode>$f; echo -n $f` \
    -X POST \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Referer: https://www.hackthebox.eu/' \
    -H 'Connection: close' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    --oF WFUZZP3 \
    -b '__cfduid=FUZZ[r.cookies.response.__cfduid]; hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    -H 'Host: www.hackthebox.eu' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d $'_token=FUZ2Z&code=FUZ3Z' \
    $'https://www.hackthebox.eu/invite' \
    
    echo ------------------------------------------------------------ wfuzz GET 'https://www.hackthebox.eu/register' : 
    wfuzz \
    -p 127.0.0.1:8080 \
    -c \
    -z 'wfuzzp,WFUZZP3' \
    -X GET \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Referer: https://www.hackthebox.eu/invite' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    -b 'hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    -H 'Host: www.hackthebox.eu' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    $'https://www.hackthebox.eu/register' \
    
We _could_ run the whole script with all 4 requests in one shot, however for the sake of analysis, we'll run it step by step instead: We copy and paste the lines up to (and including) the 1st request:<br/>

    rm -f WFUZZP?
    echo ------------------------------------------------------------ wfuzz FUZZ 'https://www.hackthebox.eu/invite' : 
    ------------------------------------------------------------ wfuzz FUZZ https://www.hackthebox.eu/invite :
    wfuzz \
    > -p 127.0.0.1:8080 \
    > -c \
    > -z 'list,GET' \
    > -X FUZZ \
    > -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > -H 'Accept-Language: en-US,en;q=0.5' \
    > -H 'Pragma: no-cache' \
    > -H 'Cache-Control: no-cache' \
    > --oF WFUZZP1 \
    > -H 'Host: www.hackthebox.eu' \
    > -H 'Content-Type: application/x-www-form-urlencoded' \
    > $'https://www.hackthebox.eu/invite' \
    > 
    
    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    ********************************************************
    * Wfuzz 2.4.5 - The Web Fuzzer                         *
    ********************************************************
    
    Target: https://www.hackthebox.eu/invite
    Total requests: 1
    
    ===================================================================
    ID           Response   Lines    Word     Chars       Payload                                                                                                                                                                                          
    ===================================================================
    
    000000001:   200        0 L      589 W    7440 Ch     "GET"                                                                                                                                                                                            
    
    Total time: 0.933818
    Processed Requests: 1
    Filtered Requests: 0
    Requests/sec.: 1.070871
    
As opposed to _curl_ or _wget_, _wfuzz_ only returns a summary of the response to stdout.<br/>
### Introspection
There are 2 possibilities to view the details of the HTTP response:<br/>
- _Burpsuite_: The Proxy / HTTP-History tab will show you all details of each request that went through the proxy (even rendered HTML)
- _wfuzz_ payload and object introspection<br/>
Time to explain the latter concept: You might have noticed the command line argument `--oF WFUZZP1` in the most recent _wfuzz_ statement.<br/>
A `WFUZZP1` file has been created in the current directory. That file is (kind of) comparable to the cookies.txt file that _curl_ created in the previous session, however it contains much more:<br/>
It basically contains an object representation of each and every component involved in the associated HTTP request/response. You may regard it as a little database of HTTP protocol components.<br/>
How do we query this database? _wfpayload.py_ is the answer.<br/>
<sub>Note: If you have wfuzz installed on your system, however your installation lacks the wfpayload.py script (we have seen that on the kali 2020.1 release), just copy the _src/wfpayload.py_ of this repository (or the original from https://github.com/xmendez/wfuzz/src) into your $PATH.<sup>

Now, let's look at the value of a response cookie contained in WFUZZP1 with<br/>
`wfpayload.py -z 'wfuzzp,WFUZZP1' --field 'r.cookies.response.XSRF-TOKEN'`

    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    eyJpdiI6InVienM3UWFWMVd6ZG5mSFZyTUVwdWc9PSIsInZhbHVlIjoiT2UwRXp1Y2VhSzRya0ZPOG5oMnBOQnJRR1NGd1ZGTStCakF2RmQ1YVwvZU0zZm54STVMdXFzaFR1Zmp4cEdzK1oiLCJtYWMiOiIzYzE5MmM0OTI0ZTJlNjVlMmM3MGQxZTc4ZDAwOGQwYjk1NDFhNTUxY2ZmOGI1YTRiOTMxNDc2MWRlNzQ2ZmRhIn0%3D
    
Let's look at the content of the HTTP response contained in WFUZZP1 with<br/>
`wfpayload.py -z 'wfuzzp,WFUZZP1' --field "history.content"`

    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    <!DOCTYPE html> <html lang="en"> <head> <meta charset="utf-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1"> <meta name="description" content="Entry challenge for joining Hack The Box. You have to hack your way in!" /> <meta name="keywords" content="pen testing,hack,hacking,penetration testing,infosec,information security,labs"> <meta name="author" content="Hack The Box"> <meta name="google-site-verification" content="ut2KvZ-Bku4Vdbk1hfkkiX6W_Gb_9-CR9UD8ZU4B0mU" /> <meta property="og:title" content="Can you hack this box?" /> <meta property="og:url" content="https://www.hackthebox.eu" /> <meta property="og:image" content="https://www.hackthebox.eu/images/favicon.png" /> <meta property="og:site_name" content="Hack The Box" /> <meta property="fb:app_id" content="269224263502219" /> <meta property="og:description" content="An online platform to test and advance your skills in penetration testing and cyber security." /> <meta name="csrf-token" content="zxzBfQqsbIn7Fop0LwUaHiYVZrGxzzowZTfQUWhO"> <meta name="wot-verification" content="1eeefbec1f6305acd476" /> <script type='application/ld+json'> { "@context": "http://schema.org", "@type": "Organization", "url": "https://www.hackthebox.eu", "name": "Hack The Box", "contactPoint": [{ "@type": "ContactPoint", "telephone": "+44-203-6178-265", "contactType": "emergency" }], "sameAs": [ "https://www.facebook.com/hackthebox.eu", "https://www.linkedin.com/company/hackthebox", "https://twitter.com/hackthebox_eu" ], "logo": "https://www.hackthebox.eu/images/favicon.png", "description": "An online platform to test and advance your skills in penetration testing and cyber security.", "founder": { "@type": "Person", "name": "Haris Pylarinos" }, "aggregateRating": { "@type": "AggregateRating", "ratingValue": "4.95", "bestRating": "5", "worstRating": "1", "ratingCount": "787" } } </script> <script> !function(){var analytics=window.analytics=window.analytics||[];if(!analytics.initialize)if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","reset","group","track","ready","alias","debug","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t,e){var n=document.createElement("script");n.type="text/javascript";n.async=!0;n.src="https://cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(n,a);analytics._loadOptions=e};analytics.SNIPPET_VERSION="4.1.0"; analytics.load("0TfpkI8Z8dM5cArXmzVpfEBmj10vpbfI"); analytics.page("Invite"); }}(); </script> <title>Hack The Box :: Can you hack this box?</title> <link rel="canonical" href="https://www.hackthebox.eu/invite" /> <style> .native-ad #_default_ { position: relative; padding: 10px 10px; background: repeating-linear-gradient(-45deg, transparent, transparent 5px, hsla(0, 0%, 0%, .05) 5px, hsla(0, 0%, 0%, .05) 10px) hsla(203, 11%, 23%, 0.5); font-size: 14px; line-height: 1.5; } .native-ad #_default_:after { position: absolute; bottom: 0; left: 0; overflow: hidden; width: 100%; border-bottom: solid 4px #9acc15; content: ""; transition: all .2s ease-in-out; transform: scaleX(0); } .native-ad #_default_:hover:after { transform: scaleX(1); } .native-ad .default-ad { display: none; } .native-ad ._default_ { display: inline; overflow: hidden; } .native-ad ._default_ > * { vertical-align: middle; } .native-ad a { color: inherit; text-decoration: none; } .native-ad a:hover { color: inherit; } .native-ad .default-image { display: none; } .native-ad .default-title, .native-ad .default-description { display: inline; line-height: 1; } .native-ad .default-title { position: relative; margin-right: 8px; font-weight: 600; } .native-ad .default-title:before { position: absolute; top: -23px; padding: 4px 6px; border-radius: 3px; background-color: #9acc15; color: #fff; content: "Sponsor"; text-transform: uppercase; font-weight: 600; letter-spacing: 1px; font-size: 10px; line-height: 1; } </style> <link rel="stylesheet" href="https://www.hackthebox.eu/css/htb-frontend.css" /> <link rel="stylesheet" href="https://www.hackthebox.eu/css/icons.css" /> <link rel="icon" href="/images/favicon.png"> <script async src="https://www.googletagmanager.com/gtag/js?id=AW-757546894"></script> <script> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag('js', new Date()); gtag('config', 'AW-757546894'); </script> </head> <body class="blank" style="overflow-y:hidden; "> <script> (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){ (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o), m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m) })(window,document,'script','https://www.google-analytics.com/analytics.js','ga'); ga('create', 'UA-93577176-1', 'auto'); ga('set','anonymizeIp',true); ga('send', 'pageview'); </script> <div class="wrapper"> <section class="content" style="margin:0px; padding:0px;"> <div class="container-center centerbox"> <div class="view-header"> <div class="header-icon"> <i class="pe page-header-icon pe-7s-smile"></i> </div> <div class="header-title"> <h1 style="font-size:24px;margin-bottom:2px;">Invite Challenge</h1> <small> Hi! Feel free to hack your way in :) </small> </div> </div> <div class="panel panel-filled"> <div class="panel-body"> <p><span class="c-white">Hack this page to get your invite code!</span></p> <form action="https://www.hackthebox.eu/invite" id="verifyForm" method="post"> <input type="hidden" name="_token" value="zxzBfQqsbIn7Fop0LwUaHiYVZrGxzzowZTfQUWhO"> <div class="form-group "> <label class="control-label" for="code">Invite Code</label> <input type="text" title="Please enter your invite code" required="" value="" name="code" id="code" class="form-control"> <span class="help-block small"></span> </div> <div> <button class="btn btn-accent">Sign Up</button> </div> </form> </div> </div> <span class="help-block small text-center">If you are already a member click <a href="https://www.hackthebox.eu/login">here</a> to login.</span> <br> <div class="view-header"> <div class="header-icon"> <i class="pe page-header-icon pe-7s-way"></i> </div> <div class="header-title"> <h3> Want some help? </h3> <br> <div style="display: inline-block"> <button class="btn btn-accent" onclick="showHint()"> Click Here! </button> <p id="help_text" hidden><br> You could check the console... </p> </div> </div> </div> <div class="native-ad"></div> <script> (function(){ if(typeof _bsa !== 'undefined' && _bsa) { _bsa.init('default', 'CKYDLKJJ', 'placement:hacktheboxeu', { target: '.native-ad', align: 'horizontal', disable_css: 'true' }); } })(); </script> </div> <div class="particles_full" id="particles-js"></div> </section> </div> <script src="https://www.hackthebox.eu/js/htb-frontend.min.js"></script> <script defer src="/js/inviteapi.min.js"></script> <script defer src="https://www.hackthebox.eu/js/calm.js"></script> <script>function showHint() { $("#help_text").show(); }</script> </body> </html>

We can even make our query more specific by adding a regular expression to it:<br/>
`wfpayload.py -z 'wfuzzp,WFUZZP1' --field "history.content|gregex('.*input [^>]*name=._token. [^>]*value=.([^>]+).>.*')"`<br/>

    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    zxzBfQqsbIn7Fop0LwUaHiYVZrGxzzowZTfQUWhO

## 2nd request
Now that we know how the WFUZZPn files can be queried by _wfpayload.py_, we better understand the tags contained in the 2nd request in _hackthebox.wfuzz.metahttp.xml_:<br/>

    <payload type="wfuzzp" fn="WFUZZP1" description="FUZZ: read results of the 1st request"/>
    <cookie name="__cfduid" value="FUZZ[r.cookies.response.__cfduid]"/>
    <cookie name="hackthebox_session" value="FUZZ[r.cookies.response.hackthebox_session]"/>
    <cookie name="XSRF-TOKEN" value="FUZZ[r.cookies.response.XSRF-TOKEN]"/>

_metahttp_ integrates the _wfpayload.py_ queries in a way that the session cookies from the 1st request will be reused in the 2nd request. Let's copy and paste the 2nd _wfuzz_ statement in order to run it:<br/>

    wfuzz \
    > -p 127.0.0.1:8080 \
    > -c \
    > -z 'wfuzzp,WFUZZP1' \
    > -X POST \
    > -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > -H 'Accept-Language: en-US,en;q=0.5' \
    > -H 'Referer: https://www.hackthebox.eu/' \
    > -H 'Pragma: no-cache' \
    > -H 'Cache-Control: no-cache' \
    > --oF WFUZZP2 \
    > -b '__cfduid=FUZZ[r.cookies.response.__cfduid]; hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    > -H 'Host: www.hackthebox.eu' \
    > -H 'Content-Type: application/x-www-form-urlencoded' \
    > -d $'' \
    > $'https://www.hackthebox.eu/api/invite/generate' \
    > 
    
    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    ********************************************************
    * Wfuzz 2.4.5 - The Web Fuzzer                         *
    ********************************************************
    
    Target: https://www.hackthebox.eu/api/invite/generate
    Total requests: <<unknown>>
    
    ===================================================================
    ID           Response   Lines    Word     Chars       Payload                                                                                                                                                                                          
    ===================================================================
    
    000000001:   200        0 L      1 W      99 Ch       "da82d1500aa254b31552ee1ea95219deb1590765839 - eyJpdiI6IkJLWEFzSzZ0YnFaZXZ2WUhPMFZlN1E9PSIsInZhbHVlIjoiNjBEM3ptWm0zbElJSEcwXC9zazVURWpFU3dwXC85V1NrWm9YNFRcL2hzQ1JuVW45R3pBYlNZSm4weXFGV0tHMHhsSy
                                                          IsIm1hYyI6IjA5NWQzMTlkMTkxMjRkMGU5OTJlZjEwNDZlYWZkNDRmM2ZmNjQxZjBkZDU3ZDhmOTAzMTdjZDkyZDA3ZDRlZDgifQ%3D%3D - eyJpdiI6InVienM3UWFWMVd6ZG5mSFZyTUVwdWc9PSIsInZhbHVlIjoiT2UwRXp1Y2VhSzRya0ZPOG5oMnBO
                                                          QnJRR1NGd1ZGTStCakF2RmQ1YVwvZU0zZm54STVMdXFzaFR1Zmp4cEdzK1oiLCJtYWMiOiIzYzE5MmM0OTI0ZTJlNjVlMmM3MGQxZTc4ZDAwOGQwYjk1NDFhNTUxY2ZmOGI1YTRiOTMxNDc2MWRlNzQ2ZmRhIn0%3D"                              
    
    Total time: 0.729401
    Processed Requests: 1
    Filtered Requests: 0
    Requests/sec.: 1.370987

A new object file _WFUZZP2_ has been written by the 2nd request. Let's query its contents:<br/>
`wfpayload.py -z 'wfuzzp,WFUZZP2' --field "history.content"`<br/>

    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    {"success":1,"data":{"code":"VlNZVkstTUNGRlktV1BaRFctU0JHV0YtVEVaSFk=","format":"encoded"},"0":200}
We have received an invite code, still base64-encoded. Let's leave it this way for now.<br/>
<br/>
## 3rd request
Looking at _hackthebox.wfuzz.metahttp.xml_, the tag that deals with the invite code payload within the 3rd request is:<br/>

    <payload type="wfuzzp" fn="WFUZZP2" field="history.content|gregex('.*.code.:.([^,]*).,.*')" decoder="base64" description="FUZZ: read results of the 2nd request"/>

Below, you see how _metahttp_ integrates the _wfpayload.py_ call into the _wfuzz_ payload parameters (_-z_ arguments). Let's copy and paste the 3rd _wfuzz_ statement in order to run it:<br/> 

    # wfuzz \
    > -p 127.0.0.1:8080 \
    > -c \
    > -z 'wfuzzp,WFUZZP1' \
    > -z file,`f=$(mktemp); wfpayload.py -z 'wfuzzp,WFUZZP1' --field "history.content|gregex('.*input [^>]*name=._token. [^>]*value=.([^>]+).>.*')" | grep -vE "^$|^Warning:">$f; echo -n $f` \
    > -z file,`f=$(mktemp); wfpayload.py -z 'wfuzzp,WFUZZP2' --field "history.content|gregex('.*.code.:.([^,]*).,.*')" | grep -vE "^$|^Warning:" | base64 --decode>$f; echo -n $f` \
    > -X POST \
    > -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > -H 'Accept-Language: en-US,en;q=0.5' \
    > -H 'Accept-Encoding: gzip, deflate' \
    > -H 'Referer: https://www.hackthebox.eu/' \
    > -H 'Connection: close' \
    > -H 'Pragma: no-cache' \
    > -H 'Cache-Control: no-cache' \
    > --oF WFUZZP3 \
    > -b '__cfduid=FUZZ[r.cookies.response.__cfduid]; hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    > -H 'Host: www.hackthebox.eu' \
    > -H 'Content-Type: application/x-www-form-urlencoded' \
    > -d $'_token=FUZ2Z&code=FUZ3Z' \
    > $'https://www.hackthebox.eu/invite' \
    > 
    
    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    ********************************************************
    * Wfuzz 2.4.5 - The Web Fuzzer                         *
    ********************************************************
    
    Target: https://www.hackthebox.eu/invite
    Total requests: <<unknown>>
    
    ===================================================================
    ID           Response   Lines    Word     Chars       Payload                                                                                                                                                                                          
    ===================================================================
    
    000000001:   302        10 L     22 W     333 Ch      "da82d1500aa254b31552ee1ea95219deb1590765839 - eyJpdiI6IkJLWEFzSzZ0YnFaZXZ2WUhPMFZlN1E9PSIsInZhbHVlIjoiNjBEM3ptWm0zbElJSEcwXC9zazVURWpFU3dwXC85V1NrWm9YNFRcL2hzQ1JuVW45R3pBYlNZSm4weXFGV0tHMHhsSy
                                                          IsIm1hYyI6IjA5NWQzMTlkMTkxMjRkMGU5OTJlZjEwNDZlYWZkNDRmM2ZmNjQxZjBkZDU3ZDhmOTAzMTdjZDkyZDA3ZDRlZDgifQ%3D%3D - eyJpdiI6InVienM3UWFWMVd6ZG5mSFZyTUVwdWc9PSIsInZhbHVlIjoiT2UwRXp1Y2VhSzRya0ZPOG5oMnBO
                                                          QnJRR1NGd1ZGTStCakF2RmQ1YVwvZU0zZm54STVMdXFzaFR1Zmp4cEdzK1oiLCJtYWMiOiIzYzE5MmM0OTI0ZTJlNjVlMmM3MGQxZTc4ZDAwOGQwYjk1NDFhNTUxY2ZmOGI1YTRiOTMxNDc2MWRlNzQ2ZmRhIn0%3D - zxzBfQqsbIn7Fop0LwUaHiYVZrGx
                                                          zzowZTfQUWhO - VSYVK-MCFFY-WPZDW-SBGWF-TEZHY"                                                                                                                                                    
    
    Total time: 0.596053
    Processed Requests: 1
    Filtered Requests: 0
    Requests/sec.: 1.677700

Like in the _curl_ example (see above), the redirection (code 302) is an indicator that the request was successful and we get redirected to the _/register_ page with valid codes (please also note the decoded invite code `VSYVK-MCFFY-WPZDW-SBGWF-TEZHY` within the _Payload_ column).<br/>
<br/>
## 4th request
This time, we are actually going to request the _/register_ page with the cookies that we received in the session so far.
Copy and paste the 4th _wfuzz_ statement:<br/>

    wfuzz \
    > -p 127.0.0.1:8080 \
    > -c \
    > -z 'wfuzzp,WFUZZP3' \
    > -X GET \
    > -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:60.0) Gecko/20100101 Firefox/60.0' \
    > -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    > -H 'Accept-Language: en-US,en;q=0.5' \
    > -H 'Referer: https://www.hackthebox.eu/invite' \
    > -H 'Pragma: no-cache' \
    > -H 'Cache-Control: no-cache' \
    > -b 'hackthebox_session=FUZZ[r.cookies.response.hackthebox_session]; XSRF-TOKEN=FUZZ[r.cookies.response.XSRF-TOKEN]' \
    > -H 'Host: www.hackthebox.eu' \
    > -H 'Content-Type: application/x-www-form-urlencoded' \
    > $'https://www.hackthebox.eu/register' \
    > 
    
    Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
    
    ********************************************************
    * Wfuzz 2.4.5 - The Web Fuzzer                         *
    ********************************************************
    
    Target: https://www.hackthebox.eu/register
    Total requests: <<unknown>>
    
    ===================================================================
    ID           Response   Lines    Word     Chars       Payload                                                                                                                                                                                          
    ===================================================================
    
    000000001:   200        1 L      743 W    11018 Ch    "eyJpdiI6InY5blBhTTNXU0tQaUV1SUx2NnBmZXc9PSIsInZhbHVlIjoiTUM4Vk9uVDRmWWticThUY3U0VjN6aHY1MVIyT1g3MmZhMlk5VWtjVXZQcVJHZFVmM1BlamQwUWpEM2pFakhENSIsIm1hYyI6Ijg4YWFkZDExM2NhNDMxMzFkNDI3MjcxMDE0MTc0
                                                          MzE2YzM4OGMxODc1ODkyNzA0NzllOTE1ZmU5OGYyNzQxODAifQ%3D%3D - eyJpdiI6Ikh1OVd5Y0ZwNTU4K3RFQlwvWG1SanZ3PT0iLCJ2YWx1ZSI6IkgrRjVEMlpFdGhyRmRITXlPb2NYa0E2YTVzUWxNQVNudFBZbVhQY01JdDBSaEhKMkc0RjJoVHc1aj
                                                          lrMm9tRUMiLCJtYWMiOiIzOGU1M2UwMWNkNjdjYTZlNjNhMTRlOTE3YjZlN2U4MjkwNDlhOTRmMzVmMTczMmQwNmUxNGIxZGYyOWMxMmU5In0%3D"                                                                                
    
    Total time: 0.717396
    Processed Requests: 1
    Filtered Requests: 0
    Requests/sec.: 1.393928
    
Looks promising. To confirm, let's check BurpSuite proxy to see what response the request received:<br/>
![BurpSuite Proxy](/images/burp-proxy-raw-register-response1.png)
<br/>
## 5th request ?
As we can see in the highlighted part of the HTML that BurpSuite shows us, all the codes are set up nicely for our actual user registration.<br/>
So you might ask, why don't we create a 5th request that includes a name, email, password, accepts the TOS and kicks off the actual automated registration per POST request?<br/>
The reason we can __*not*__ automate this 5th request is a required form field called __*g-recaptcha-response*__. It needs to contain the result code of the Google _Recaptcha_ service that can _only_ be retrieved through _manual_ interaction in the browser (clicking images with crosswalks and the like to prove you're not a robot).<br/>
<br/>
What you _can_ do though is hijack your own browser session by setting the cookies (e.g. via Firefox plugin) and codes (via developer tools) that you retrieved through _wfuzz_, click through the little Recaptcha challenge ... and shoot!
