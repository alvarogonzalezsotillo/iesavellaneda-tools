


BANNER="
[org/gnome/login-screen]
banner-message-enable=true
banner-message-text='Este ordenador se pone disposición de los alumnos por parte del IES Alonso de Avellaneda. Está sujeto a las condiciones de uso generales del aula y particulares de cada clase y profesor. Su uso está destinado exclusivamente a tareas académicas.\n\nCon el fin de garantizar su uso correcto y conservación, el personal del instituto podrá monitorizar las actividades realizadas en este ordenador, así como acceder a la información guardada y modificarla en caso necesario.'
logo='/usr/share/pixmaps/logo-iesavellaneda.png'
"

GREETERCONF="/etc/gdm3/greeter.dconf-defaults"

check_logo_installed(){
    grep "^logo=" "$GREETERCONF"
}

uninstall_logo(){
    sed -i '/\[org\/gnome\/login-screen\]/d' "$GREETERCONF"
    sed -i '/^logo=/d' "$GREETERCONF"
    sed -i '/^banner-message-text=/d' "$GREETERCONF"
    sed -i '/^banner-message-enable=/d' "$GREETERCONF"
}

install_logo(){
    printf "%s\n" "$BANNER" >> "$GREETERCONF"
}

if [ "$1" = "-u" ]
then
    if uninstall_logo
    then
        echo "Logotipo desinstalado de $GREETERCONF"
    else
        echo "Error desinstalando logotipo (¿sudo?)"
    fi
    exit    
fi


if check_logo_installed
then
    echo "El logotipo ya está instalado"
else
    uninstall_logo
    if install_logo
    then
        echo "Logotipo instalado en $GREETERCONF"
    else
        echo "Error instalando logotipo (¿sudo?)"
    fi
fi
    



