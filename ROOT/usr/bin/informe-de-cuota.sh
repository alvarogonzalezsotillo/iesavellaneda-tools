#!/bin/bash

dialogo(){

    local MSG="$*"
    

    if which kdialog
    then
        kdialog --title Aviso de cuota --msgbox "$MSG"
        return 0
    fi

    if which zenity
    then
        zenity --info --title "Aviso de cuota" --text "$MSG"
        return 0
    fi
    

    return 1
}


IFS="\n" quota | tail -n +3 | awk '{print $2 " " $4 " " $1}' | while read LINEA
do
    LINEA=$(echo "$LINEA" | tr -d '*')
    read USADO MAXIMO DISCO < <(echo "$LINEA")

    echo "Usado-maximo-disco:" $USADO $MAXIMO $DISCO

    if [ $MAXIMO -gt 0 ]
    then

        PORCENTAJE=$((100*USADO/MAXIMO))

        MSG="Se han usado $USADO KB de un máximo de $MAXIMO KB ($PORCENTAJE %) del disco  $DISCO"
        notify-send --category=Aviso "$MSG"  > /dev/null 2> /dev/null

        echo "$MSG"
        if [ $PORCENTAJE -gt 80 ]
        then
            dialogo "$MSG" > /dev/null 2> /dev/null
        fi
    fi
done 
