#!/bin/bash

# Definir la ruta base usando $HOME o $SUDO_USER
BASE_PATH="$HOME/pi_wireguard"

# Verificar si el directorio y los archivos existen
if [ ! -d "$BASE_PATH" ]; then
    echo "Error: El directorio $BASE_PATH no existe."
    exit 1
fi

if [ ! -f "$BASE_PATH/checkSO.sh" ]; then
    echo "Error: El archivo $BASE_PATH/checkSO.sh no existe."
    exit 1
fi

if [ ! -f "$BASE_PATH/solveDNS.sh" ]; then
    echo "Error: El archivo $BASE_PATH/solveDNS.sh no existe."
    exit 1
fi

if [ ! -f "$BASE_PATH/pi_wireguard.sh" ]; then
    echo "Error: El archivo $BASE_PATH/pi_wireguard.sh no existe."
    exit 1
fi

# Ejecutar los scripts
bash $BASE_PATH/checkSO.sh
sleep 5

#bash $BASE_PATH/solveDNS.sh
#sleep 5

bash $BASE_PATH/pi_wireguard.sh
