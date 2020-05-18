#!/bin/bash
xslt=${1:?Usage:$0 <stylesheet.xslt> (pipe xml as STDIN)}
param0=$2
param1=$3
param2=$4
saxonjar=/usr/lib/saxon9he.jar
if [[ -z "$param0" ]]; then
	java -jar ${saxonjar} -xsl:${xslt} -s:-
else
        if [[ -z "$param1" ]]; then
                java -jar ${saxonjar} -xsl:${xslt} -s:- "${param0}"
        else
                if [[ -z "$param2" ]]; then
                        java -jar ${saxonjar} -xsl:${xslt} -s:- "${param0}" "${param1}"
                else
                        java -jar ${saxonjar} -xsl:${xslt} -s:- "${param0}" "${param1}" "${param2}"
                fi
        fi
fi

