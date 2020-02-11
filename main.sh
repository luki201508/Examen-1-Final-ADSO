#!/bin/bash
# Titulo de fondo
BACKTITLE="GESTION DE USUARIOS"
# Mensaje del menu principal
MSGBOX=$(cat << END
Ve eligiendo las diferentes opciones y asegurate
de tener de completar todos los campos obligatorios.
Elige una casilla:
END
)

# Seleccion por defecto
default_page=UserName

# Declaracion de variables
let username
let group
home_directory="/home"
let uid

# Salir del programa con su respectivo codigo y eliminar cualquier archivo temporal
exit_program() {
	rm -f /tmp/user-management.tmp.*
	clear
	case $1 in
		1) echo "Program terminated";;
		255) echo "Program aborted"
			exit 1;;
	esac
	exit
}

error_message() {
	dialog	--clear \
		--title "[!ERROR¡]" \
		--backtitle "$BACKTITLE" \
		--msgbox "$1" 10 30

}

# Menu principal
main_menu() {
	dialog  --clear \
		--title "[Linux User Management]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Cancelar" \
		--default-item $default_page \
		--menu "$MSGBOX" 20 0 20 \
		UserName "Ponga el nombre de usuario" \
		Group	"Elija entre los grupos existentes" \
		Id	"Ponga un id" \
		Home	"Establezca el directorio Home" \
		VerFichero "Ver el fichero donde se guardan los usuarios" \
		VerInfo "Ver la informacion metida por el usuario" \
		Añadir	"Añadir usuario al sistema" \
		Salir	"Salir del programa" \
		2> /tmp/user-management.tmp.$$
	if [ ! $? -eq 0 ]
	then
		exit_program $?
	fi
	# Asignar la opcion elegida
	option=$(cat /tmp/user-management.tmp.$$)
}

# Caja de texto para el nombre de usuario
username_input() {
	dialog  --clear \
		--title "[Pon un nombre de usuario]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Cancelar" \
		--inputbox "Nombre de usuario" 8 60 "$username" \
		2> /tmp/user-management.tmp.$$
	# Lo guardamos en la variable
	username=$(cat /tmp/user-management.tmp.$$)
	# Establecemos que la pagina por defecto sea la actual
	default_page=UserName
}

# Caja de text para el grupo
group_input() {
	dialog  --clear \
		--title "[Añadir a grupo]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Cancelar" \
		--inputbox "Nombre del grupo" 8 60 "$group" \
		2> /tmp/user-management.tmp.$$
	group=$(cat /tmp/user-management.tmp.$$)
	# En caso de no existir el grupo dara un mensaje de error
	if [ -z $(getent group $group) ] # Si el grupo no existe, este comando devuelve vacio
	then
		group="" # Reseteamos la variable de la caja de texto
		dialog	--clear \
			--title "[!ERROR¡]" \
			--backtitle "$BACKTITLE" \
			--msgbox "El grupo que ha puesto no existe" 10 30
	fi
	default_page=Group
}

id_input() {
	dialog  --clear \
		--title "[Identificador unico]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Cancelar" \
		--inputbox "ID unico" 8 20 "$uid" \
		2> /tmp/user-management.tmp.$$
	uid=$(cat /tmp/user-management.tmp.$$)
	# Si los datos metidos no son de tipo numero lanza un error
	if ! [ "$uid" -eq $uid ]
	then
		uid=""
		error_message "El id debe ser de tipo numerico entero positivo"
	fi
	# Si el uid es negativo lanza un error
	if [ $uid -lt 0 ]
	then
		uid=""
		error_message "El id debe ser positivo"
	fi
	# Si el id ya existe lanza un error
	if [ ! -z $(getent passwd $uid) ]
	then
		uid=""
		error_message "El id puesto ya existe ponga otro"
	fi
	default_page=Id
}

home_input() {
	if [ ! -z "$username" ] && [ "$home_directory" == "/home" ]
	then
		home_directory="$home_directory/$username"
	fi
	dialog  --clear \
		--title "[Directorio Home]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Cancelar" \
		--inputbox "Ponga la direccion del Home" 8 20 "$home_directory" \
		2> /tmp/user-management.tmp.$$
	home_directory=$(cat /tmp/user-management.tmp.$$)
	default_page=Home
}

ver_fichero_usuarios() {
	dialog  --clear \
		--title "[/etc/passwd]" \
		--backtitle "$BACKTITLE" \
		--exit-label "Atrás" \
		--textbox /etc/passwd 40 70
	default_page=VerFichero
}

add_user() {
	if [ -z "$username" ] || [ -z "$group" ] || [ -z "$home_directory" ] || [ -z "$uid"]
	then
		error_message "Hay campos sin rellenar"
	else
		gid=$(getent group $group | awk -F ":" '{print $3}')
		user_info="$username::$uid:$gid:usuario $username:$home_directory:/bin/bash"
		dialog  --clear \
			--title "[Añadir usuario]" \
			--backtitle "$BACKTITLE" \
			--yesno "Crear $user_info?" 10 60
		option_add_user=$?
		if [ $? -eq 0 ]
		then
			echo "$user_info" >> /etc/passwd && mkdir -p $home_directory
		fi
	fi
	default_page=Añadir
}

ver_info_usuario() {
	INFO="Nombre de usuario: $username
	Nombre de grupo: $group
	UID del usuario: $uid
	Directorio home: $home_directory"
	dialog  --clear \
		--title "[Usuario info]" \
		--backtitle "$BACKTITLE" \
		--ok-label "Aceptar" \
		--cancel-label "Atrás" \
		--msgbox "$INFO" 10 40
	default_page=VerInfo
}

# Programa principal
# Bucle infinito hasta que cierre
while true; do
	main_menu
	case $option in
		0) exit_program 1 ;;
		UserName) username_input ;;
		Group) group_input ;;
		Id) id_input ;;
		Home) home_input ;;
		VerFichero) ver_fichero_usuarios ;;
		VerInfo) ver_info_usuario ;;
		Añadir) add_user ;;
		Salir) exit_program 1 ;;
	esac
done

exit 0


