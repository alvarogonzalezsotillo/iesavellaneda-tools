#!/bin/bash
while true
do
    MSG="$(quota | tail -n 1 | awk '{print "Has usado " $2 " de " $4 " bytes en el disco"}')"
    echo "MSG es:$MSG"
    if ! [ "$MSG" ]
    then
        MSG="No se han definido cuotas para el usuario actual ($USER)"
    fi
    notify-send "$MSG"
    sleep 1h
done;
