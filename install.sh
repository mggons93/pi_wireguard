#!/bin/bash

# Definir la ruta base usando $SUDO_USER para obtener el usuario original
BASE_PATH="/home/$SUDO_USER/pi_wireguard"

# Ejecutar los scripts
bash $BASE_PATH/checkSO.sh
sleep 5

bash $BASE_PATH/solveDNS.sh
sleep 5

bash $BASE_PATH/pi_wireguard.sh
