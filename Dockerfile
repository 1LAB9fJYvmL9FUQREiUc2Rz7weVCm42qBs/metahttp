FROM ubuntu:16.04
LABEL maintainer="ubuntu 16.04 with essentials/jre/saxon/socat/metahttp"
RUN apt update
RUN apt install -y iproute2
RUN apt install -y build-essential
RUN apt install -y default-jre
#RUN apt install -y netcat-traditional
RUN apt install -y socat
VOLUME /tmp
COPY src/saxon9he.jar /usr/lib/
COPY src/metahttp-compiler.xslt /usr/lib/
COPY src/xslt.sh /usr/local/bin/
COPY src/metahttp.sh /usr/local/bin/
COPY src/exec-wrapper.sh /usr/local/bin/
COPY src/startup-servers.sh /usr/local/bin/
#ENTRYPOINT /usr/bin/socat TCP4-LISTEN:50774,fork,reuseaddr "EXEC:'exec-wrapper.sh metahttp.sh',pipes"
ENTRYPOINT ["/usr/local/bin/startup-servers.sh"]
EXPOSE 50774/tcp
EXPOSE 50774/udp
