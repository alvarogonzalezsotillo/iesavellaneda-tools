#!/bin/bash
IFS="\n" quota | tail -n +3 | awk '{print $2 " " $4 " " $1}' | while read LINEA
do
    read USADO MAXIMO DISCO < <(echo "$LINEA")

    PORCENTAJE=$((100*USADO/MAXIMO))

    MSG="Se han usado  $USADO KB de un máximo de $MAXIMO KB ($PORCENTAJE %) del disco  $DISCO"

    echo "$MSG"
    if [ $PORCENTAJE -gt 80 ]
    then
        notify-send --category=Aviso "Aviso de cuota" "$MSG"  > /dev/null 2> /dev/null
    fi
done 
