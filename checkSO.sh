#!/bin/bash

# Obtener la versión de Ubuntu
VERSION=$(lsb_release -r | awk '{print $2}')

# Comprobar si la versión es 20.04
if [ "$VERSION" == "20.04" ]; then
    echo "Estás en Ubuntu 20.04. No es necesario realizar la actualización."
else
    echo "Tu versión de Ubuntu no es 20.04. Iniciando la actualización..."

    # Ejecutar la actualización automáticamente sin intervención
    sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y

    # Realizar la actualización a la siguiente versión
    sudo do-release-upgrade -f DistUpgradeViewNonInteractive

    # Esperar unos segundos antes de reiniciar, para asegurarse de que el proceso de actualización haya terminado
    echo "Actualización completada. Reiniciando el sistema..."
    sleep 5  # espera 5 segundos

    # Añadir el script `install.sh` a cron para que se ejecute al reiniciar
    echo "@reboot /home/ubuntucore/install.sh" | sudo tee -a /etc/crontab > /dev/null


    # Reiniciar el sistema automáticamente
    sudo reboot
fi
