#!/bin/bash

# Obtener la versión de Ubuntu
VERSION=$(lsb_release -r | awk '{print $2}')
VERSION_MAJOR=$(echo $VERSION | cut -d '.' -f 1)
VERSION_MINOR=$(echo $VERSION | cut -d '.' -f 2)

# Comprobar si la versión es 20.04 o superior
if [ "$VERSION_MAJOR" -ge 24 ]; then
    echo "Estás en Ubuntu $VERSION. No es necesario realizar la actualización, ya que tu versión es 24.04 o superior."
    exit 0
else
    echo "Tu versión de Ubuntu es inferior a 24.04. Se procederá con la actualización."
fi

# Actualizar todos los paquetes disponibles
echo "Actualizando lista de paquetes..."
sudo apt update -y

echo "Actualizando paquetes del sistema..."
sudo apt upgrade -y

echo "Realizando dist-upgrade para una actualización más profunda..."
sudo apt dist-upgrade -y

# Limpiar paquetes no necesarios
echo "Limpiando paquetes obsoletos..."
sudo apt autoremove -y

# Realizar la actualización a la siguiente versión de Ubuntu
echo "Iniciando la actualización de la versión de Ubuntu..."
sudo do-release-upgrade -f DistUpgradeViewNonInteractive

# Comprobar si la actualización fue exitosa
if [ $? -eq 0 ]; then
    echo "Actualización completa."

    # Comprobar si el kernel fue actualizado
    if [ -f /var/run/reboot-required ]; then
        echo "Se requiere un reinicio para aplicar los cambios. Reiniciando el sistema..."
        sudo reboot
    else
        echo "No se requiere reinicio. El sistema está completamente actualizado."
    fi
else
    echo "Hubo un error durante la actualización."
    exit 1
fi
