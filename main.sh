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

