#!/bin/bash
port=${1:-50774}
/usr/bin/socat TCP4-LISTEN:${port},fork,reuseaddr EXEC:'exec-wrapper.sh metahttp-server.sh',nofork,stderr &
/usr/bin/socat UDP4-LISTEN:${port},fork,reuseaddr EXEC:'exec-wrapper.sh metahttp-server.sh',nofork,stderr &
/bin/bash
