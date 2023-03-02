#!/bin/bash

TAG=tag-instalar-logo-sin-comprobar
DEB_URL=https://github.com/alvarogonzalezsotillo/iesavellaneda-tools/releases/download/$TAG/iesavellaneda-tools.deb
AULA_DEFECTO=a33

nombres_de_ordenadores_de_alumno()(
    local AULA=${1:-$AULA_DEFECTO}
    for ORDENADOR in $(seq 1 16)
    do
        printf "%spc%02d.local\n" $AULA $ORDENADOR
    done
)

detecta_parallel_ssh(){
    if ! which parallel-ssh > /dev/null
    then
        echo "Se necesita parallel-ssh. Se instala con:"
        echo "   sudo apt install pssh"
        exit 1
    fi
}

detecta_parallel_ssh

AULA=$(whiptail --inputbox "Aula donde instalar iesavellaneda-tools:" 10 30 "$AULA_DEFECTO" 3>&1 1>&2 2>&3)
if [ $? -ne 0 ]
then
    echo Instalación cancelada
    exit 1
fi

USUARIO=$(whiptail --inputbox "Usuario para conectarse (root o con sudo sin contraseña):" 10 30 profesor 3>&1 1>&2 2>&3)
if [ $? -ne 0 ]
then
    echo Instalación cancelada
    exit 1
fi

echo "--------"
echo "--------"
echo Se solicitará la contraseña del usuario $USUARIO en los ordenadores de los alumnos
if [ $USUARIO != root ]
then
    echo El usuario $USUARIO debe tener capacidad de realizar sudo sin contraseña
fi
echo "--------"
echo "--------"

mkdir -p outdir
parallel-ssh --hosts <(nombres_de_ordenadores_de_alumno $AULA) --timeout 20 --askpass --user $USUARIO --errdir outdir --outdir outdir --extra-args "-o StrictHostKeyChecking=no" "wget -O iesavellaneda-tools.deb $DEB_URL; sudo apt install ./iesavellaneda-tools.deb; rm iesavellaneda-tools.deb" 

echo "--------"
echo "--------"
echo Los resultados están en el directorio outdir


