#!/bin/bash
port=${1:-50774}
cat - | nc localhost ${port}

