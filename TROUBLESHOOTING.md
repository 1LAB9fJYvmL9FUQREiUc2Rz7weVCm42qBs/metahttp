# Troubleshooting<br/>
As of v1.1 there was some socat misconfiguratrion that prevented stderr output to show up when piping the code through the TCP sockets.<br/>
In case that your metadata compilation comes back empty from the socket, then this is an indication that there was a compilation error.<br/>
In order to see the error information, here's what you can do:
As you can see in the Dockerfile, volume /tmp is a mountpoint. In order to see where it is mounted, use command `docker inspect ubuntu1604-socat-metahttp | grep -i -A 4 mounts`
    "Mounts": [
        {
            "Type": "volume",
            "Name": "06ca5fbc58f230c37ee7f1649479018dba6bef1e4a88ee9be19115f36b212c04",
            "Source": "/var/lib/docker/volumes/06ca5fbc58f230c37ee7f1649479018dba6bef1e4a88ee9be19115f36b212c04/_data",

Create a symbolic link to the Source:<br/>
`ln -s /var/lib/docker/volumes/06ca5fbc58f230c37ee7f1649479018dba6bef1e4a88ee9be19115f36b212c04/``_``data tmp`<br/>
... and copy the file that was not compiling correctly over to /tmp:<br/>
`cp meta/hackthebox.wfuzz.metahttp.xml tmp/`

Now attach to a shell _inside_ the docker container with: `docker attach ubuntu1604-socat-metahttp`<br/>

    root@1569dac4138c:/usr/local/bin# 
    root@1569dac4138c:/usr/local/bin# 
    root@1569dac4138c:/usr/local/bin# cat /tmp/hackthebox.wfuzz.metahttp.xml | socat - EXEC:'exec-wrapper.sh metahttp.sh',nofork,stderr
    Error on line 39 column 71 
      SXXP0003: Error reported by XML parser: The value of attribute "field" associated with an
      element type "payload" must not contain the '<' character.
    org.xml.sax.SAXParseException; lineNumber: 39; columnNumber: 71; The value of attribute "field" associated with an element type "payload" must not contain the '<' character.

See above: The stderr output will help you correct your metadata.<br/>

Hint: to quit the docker interactive session without exiting the docker container, press escape sequence `ctrl-p/ctrl-q`<br/>

    root@1569dac4138c:/usr/local/bin# read escape sequence


