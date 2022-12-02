#!/bin/bash

set -o pipefail
set -u
set -e


cambiar_hostname(){
    local NEW_HOSTNAME=$1
    local CUR_HOSTNAME=$(cat /etc/hostname)

    # Change the hostname
    sudo hostnamectl set-hostname $NEW_HOSTNAME
    sudo hostname $NEW_HOSTNAME

    # Change hostname in /etc/hosts & /etc/hostname
    sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
    sudo sed -i "s/$CUR_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname

    # Display new hostname
    echo "The new hostname is $NEW_HOSTNAME"
}


if [ "${1:-}" == "" ]
then
    CUR_HOSTNAME=$(cat /etc/hostname)
    NEW_HOSTNAME=$(whiptail --inputbox "Nuevo nombre de equipo (ahora es $CUR_HOSTNAME):" 10 30 "$CUR_HOSTNAME" 3>&1 1>&2 2>&3)
    if [ $? -gt 0 ]
    then
        echo "Cancelado (aquí no debería llegar con set -e)"
        exit 1
    fi
else
    NEW_HOSTNAME=$1
fi

cambiar_hostname $NEW_HOSTNAME
