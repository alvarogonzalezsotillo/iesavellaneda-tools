#!/bin/bash


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


crear_usuario_no_visible()
{
	local USUARIO="recovering"
	figlet RECOVERING
	sudo deluser $USUARIO
	sudo adduser --system --shell /bin/bash --home "/var/recovering" $USUARIO
	echo $USUARIO:$(printf "XXXX XXXX XXXX XXXX" | xxd -r -p) | sudo chpasswd
	poner_clave_ssh recovering

}

poner_password_root()
{
	echo root:$(printf "XXXX XXXX XXXX XXXX" | xxd -r -p) | sudo chpasswd
}


borrar_usuarios(){
	USUARIOSABORRAR="user user1 dam1ed2015 dam1ed2016 dam1 usuariom usariom usuariot usariot alumnom alumnot examen alumnott alumnom1 alumnom2 alumnot1 alumnot2"

	figlet BORRANDO USUARIOS
	echo SE VAN A BORRAR LOS USUARIOS:$USUARIOSABORRAR
	echo Pulsa CTRL-C para cancelar, INTRO para seguir ; read

	for i in $USUARIOSABORRAR
	do
	    echo BORRANDO $i
	    sudo deluser --remove-all-file $i 2>/dev/null
	    sudo rm -r /media/$i 2>/dev/null
	done
}

crear_usuarios(){
	USUARIOS="alumnom alumnot"
	blocksoftlimit=250000000
	blockhardlimit=300000000
	inodesoftlimit=0
	inodehardlimit=0
	DISPOSITIVOHOME=/dev/nvme0n1p3

	figlet CREANDO USUARIOS
	echo SE VAN A CREAR LOS USUARIOS:$USUARIOS
	echo CON CUOTA: $blocksoftlimit $blockhardlimit
	echo EN DISPOSITIVO: $DISPOSITIVOHOME
	echo Pulsa CTRL-C para cancelar, INTRO para seguir ; read

	for i in $USUARIOS
	do
		echo CREANDO $i
		yes $i | sudo adduser --disabled-password $i
		sudo usermod -a -G vboxusers $i
		echo "$i:$i" | sudo chpasswd
		echo CUOTA PARA EL USUARIO $i
		sudo setquota -u $i  $blocksoftlimit $blockhardlimit $inodesoftlimit $inodehardlimit $DISPOSITIVOHOME
		poner_clave_ssh $i
	done
}

informe(){
	figlet REPQUOTA
	sudo repquota -s /home

	figlet Uso de disco
	df -h | grep -v snap | grep -v cgroup | grep -v tmpfs
}


borrar_usuarios
crear_usuarios
crear_usuario_no_visible
poner_password_root
informe

