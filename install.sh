#!/bin/bash

# Definir la ruta base
BASE_PATH="/home/$USER/pi_wireguard"

# Ejecutar los scripts
bash $BASE_PATH/checkSO.sh
sleep 5

bash $BASE_PATH/solveDNS.sh
sleep 5

bash $BASE_PATH/pi_wireguard.sh
