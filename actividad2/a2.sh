#!/usr/bin/env bash

# usuario de GitHub
GITHUB_USER=""

# mensaje de ingreso del nombre de usuario de GitHub
echo -n "Ingrese su nombre de usuario de GitHub: "

# Lectura de la variable con el nombre de usuario de GitHub
read -r GITHUB_USER

# si la variable está vacía, establecer un valor predeterminado
if [ -z "${GITHUB_USER}" ];then
    GITHUB_USER="J-Ajsivinac"
fi

# obtener los datos del usuario de GitHub
# curl -> realiza una petición HTTP GET
# jq -> es una herramienta de línea de comandos para procesar JSON
# -r -> muestra la salida sin comillas
# @tsv -> convierte la salida en formato TSV (tab-separated values)
read user_id user_created_at < <(curl "https://api.github.com/users/${GITHUB_USER}" | jq -r '[.id, .created_at] | @tsv')

# formatear la fecha
user_created_at=$(date -d "${user_created_at}" +%Y-%m-%d)

# contenido del saludo
content="Hola ${GITHUB_USER}. User ID: ${user_id}. Cuenta creada el: ${user_created_at}."

# Obtener la fecha actual y formatearla
date=$(date +%Y-%m-%d)

# ruta del archivo
path="/tmp/${date}/saludos.log"

# crear el directorio si no existe
mkdir -p $(dirname $path)

# escribir el contenido en el archivo
echo "${content}" >>  $path


# agregar el script al crontab
# crontab -l -> lista las tareas programadas
# 2>/dev/null -> redirige los errores a /dev/null
# realpath -> devuelve la ruta absoluta de un archivo
# */5 * * * * -> se ejecuta cada 5 minutos
# crontab - -> establece la nueva configuración
(crontab -l 2>/dev/null; echo "*/5 * * * * $(realpath $0)") | crontab -