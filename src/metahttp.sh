#!/bin/bash
param0=$1
param1=$2
param2=$3
xslt="/usr/lib/metahttp-compiler.xslt"
if [[ -z "$param0" ]]; then
    cat - | xslt.sh ${xslt}
else
    if [[ -z "$param1" ]]; then
        cat - | xslt.sh ${xslt} "${param0}"
    else
        if [[ -z "$param2" ]]; then
            cat - | xslt.sh ${xslt} "${param0}" "${param1}"
        else
            cat - | xslt.sh ${xslt} "${param0}" "${param1}" "${param2}"
        fi
    fi
fi
