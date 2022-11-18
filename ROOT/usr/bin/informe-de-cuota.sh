#!/bin/bash
MSG="$(quota | tail -n 1 | awk '{print "Has usado " $2 " de " $4 " bytes en el disco"}')"
if ! [ "$MSG" ]
then
    MSG="No se han definido cuotas para el usuario actual ($USER)"
fi
echo MSG
