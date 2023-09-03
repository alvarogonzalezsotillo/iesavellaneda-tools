#!/bin/sh


poner_clave_ssh()
{
    local ALUMNO=$1
    cat  > /tmp/clave-publica-alvaro <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4KaqlRew3gseTmkwUDyXx0Hg6pgHsqmcnbG2XOAAG7FYS/d7iYqEzlyG1nV9lhifw0Kh37mB3Kd/A9WMfutAQkFuQ3g3BJk1s/cwctJWaLnCcB2crFqSxbvBssCykM3s9K4jRGIx3FT5BPoPPr4HrOS06gyKLgs4dfRadhyoDQtInH1VvN1dV9AG3tiI/qKWrYi/hqO4JOOEICbDAsc5eZf2mXthAANiMozwo1nE/5JnfMQ6ehBIC7p2Jj46Eyl2qJ8ebz6TQYEjQAVuDDZCh3f6Kz1GfXg0NnSbSAQMam7MVIiul1Ou+BErWSatrPYaUuTWfFjoRUUlFywAqU3ngHvHLEdmg6fztxAomZeQi2qqh1ap9pUuBmj2yJg3CuFJsOWGHIBDimLrbbmn1HMVwVURpYBpWdCdhTi0+kf6Bh8Zn5hLTMNzrEW/x73Iao4CCX+MvhCO5YL6rzjfABDSFt7xYxF1s3F0iVCy5VC8VWLAfo2nNC7CxyZK1z97Fs0bsczin/05SbESogJeWmwBZjP3UqLc5p4UVLY2CLrBLACR1AqMQcIIAC6BOW+SxOlfUYsqNCoBQ7A7w2/4P3qOqZE/kLYtsAUaONueWfG1HGxtxMqqJNkeB4DJPlotpgWJgrHwJotK9F5emE4KpBTo58z4Jyehelt2DhsDzKnhOJQ== alvarogonzalezsotillo
EOF
    sudo mkdir -p /home/$ALUMNO/.ssh
    sudo cp /tmp/clave-publica-alvaro /home/$ALUMNO/.ssh/authorized_keys
    sudo chown -R $ALUMNO /home/$ALUMNO
    sudo chown -R $ALUMNO /home/$ALUMNO/.ssh
    sudo chown -R $ALUMNO:$ALUMNO /home/$ALUMNO/.ssh
    sudo chmod 600 /home/$ALUMNO/.ssh/authorized_keys
    echo CLAVE PRIVADA SSH INSTALADA EN USUARIO $ALUMNO

}

USUARIOSABORRAR="user user1 dam1ed2015 dam1ed2016 dam1 usuariom usariom usuariot usariot alumnom1 alumnom2 alumnom  alumnot alumnot1 alumnot2 examen alumnott"

for i in $USUARIOSABORRAR
do
    echo BORRANDO USUARIO $USUARIOABORRAR
    sudo deluser --remove-all-file $i 2> /dev/null
    sudo rm -r /media/$i
done

USUARIOS="alumnom alumnot"
blocksoftlimit=$((400000000/2))
blockhardlimit=$((500000000/2))
inodesoftlimit=0
inodehardlimit=0
for i in $USUARIOS
do
    echo CREANDO DE NUEVO EL USUARIO $i
    yes $i | sudo adduser --disabled-password $i
    sudo usermod -a -G vboxusers $i
    echo "$i:$i" | sudo chpasswd
    echo CUOTA PARA EL USUARIO $i
    sudo setquota -u $i  $blocksoftlimit $blockhardlimit $inodesoftlimit $inodehardlimit  /dev/sda1
    poner_clave_ssh $i
done
poner_clave_ssh alvarogs

echo VEAMOS EL DISCO DURO DISPONIBLE, debería estar ocupado alrededor del 2%
df -k | grep sd

