#!/bin/bash
/usr/bin/socat TCP4-LISTEN:50774,fork,reuseaddr EXEC:'exec-wrapper.sh metahttp.sh',pipes &
/usr/bin/socat UDP4-LISTEN:50774,fork,reuseaddr EXEC:'exec-wrapper.sh metahttp.sh',pipes &
/bin/bash
