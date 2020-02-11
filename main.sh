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
let home_directory
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
		dialog  --clear \
			--title "[!ERROR¡]" \
			--backtitle "$BACKTITLE" \
			--msgbox "El id debe ser de tipo numberico entero" 10 30
	fi
	# Si el id ya existe lanza un error
	if [ ! -z $(getent passwd $uid) ]
	then
		uid=""
		dialog	--clear \
			--title "[!ERROR¡]" \
			--backtitle "$BACKTITLE" \
			--msgbox "El id que ha puesto ya existe" 10 30
	fi
}

home_input() {}

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
		Salir) exit_program 1 ;;
	esac
done

exit 0


