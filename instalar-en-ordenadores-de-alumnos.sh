#!/bin/bash

TAG=tag-con-iconos
DEB_URL=https://github.com/alvarogonzalezsotillo/iesavellaneda-tools/releases/download/$TAG/iesavellaneda-tools.deb
AULA_DEFECTO=a33

nombres_de_ordenadores_de_alumno()(
    local AULA=${1:-$AULA_DEFECTO}
    for ORDENADOR in $(seq 1 16)
    do
        printf "%spc%02d.local\n" $AULA $ORDENADOR
    done
)

AULA=$(whiptail --inputbox "Aula donde instalar iesavellaneda-tools:" 10 30 "$AULA_DEFECTO" 3>&1 1>&2 2>&3)
if [ $? -ne 0 ]
then
    echo Instalación cancelada
    exit 1
fi

USUARIO=$(whiptail --inputbox "Usuario para conectarse (root o con sudo sin contraseña):" 10 30 profesor 3>&1 1>&2 2>&3)

mkdir -p outdir
echo Se solicitará la contraseña del usuario $USUARIO en los ordenadores de los alumnos
if [ $USUARIO != root ]
then
    echo El usuario $USUARIO debe tener capacidad de realizar sudo sin contraseña
fi

parallel-ssh --hosts <(nombres_de_ordenadores_de_alumno $AULA) --timeout 5 --askpass --user $USUARIO --outdir outdir --extra-args "-o StrictHostKeyChecking=no" "wget -O iesavellaneda-tools.deb $DEB_URL; sudo dpkg -i iesavellaneda-tools.deb; rm iesavellaneda-tools.deb" 




