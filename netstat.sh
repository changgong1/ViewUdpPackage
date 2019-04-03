#!/bin/sh
start="unok"
t=1 #set time
i=0
title=()
value=()
j=0
while :
do
    netstat -s -n | 
    while read line 
    do 
        if [ "${line}" == "udp:" ]||[ "${line}" == "Udp:" ]||[ "${line}" == "UDP:" ];then
            start="ok"
            j=0
            i=0
            echo "udp:"
            continue
        fi
        if [ "${start}" == "ok" ];then
            result=$(echo $line | grep ":")
            if [[ "$result" != "" ]];then
                #echo $i
                start="unok"
                let j++
                while [ $i -lt $j ]
                do
                    lenT=${#title[$i]}
                    lenV=${#value[$i]}
                    if [ $lenT -lt $lenV ];then
                        while [ $lenT -lt $lenV ]
                        do
                            title[$i]="_${title[$i]}"
                            let lenT++
                        done
                    else 
                        while [ $lenV -lt $lenT ]
                        do
                            value[$i]="_"${value[$i]}
                            let lenV++
                        done
                    fi
                    tilstr="$tilstr|${title[$i]}"
                    valstr="$valstr|${value[$i]}"
                    let i++
                done
                
                echo $tilstr
                echo $valstr
                break
            else
                title[j]=${line#* }
                value[j]=${line%% *}
                let j++
                #echo "  $line"
            fi
        fi
    done
    sleep $t
done
