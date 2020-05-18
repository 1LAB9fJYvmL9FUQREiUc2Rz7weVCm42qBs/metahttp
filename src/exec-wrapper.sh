#!/bin/bash
process=${1:-"cat"}	# default is using cat, which acts as an echo server
signal='SIGHUP'
timeout=30
# while piping through the components, process tends to hang as it does not recognize EOF (until cat timeout fires).
# to mitigate, parallel tee flow gets pid of the cat process by listing the subprocesses of $! (exec-wrapper.sh) and picking the 2nd one.
# by sending SIGHUP to the cat process, process flow continues and parent process terminates successfully.
{
  tee >(
    echo $! | xargs ps --format pid --ppid | xargs echo | cut -d' ' -f2 \
    | xargs kill -${signal}
  ) ; 
} < \
<(
  timeout ${timeout} cat - \
  | tee l2r \
  | bash -c "${process}" \
  | tee r2l
)

