# Obtener la versión de Ubuntu
VERSION=$(lsb_release -r | awk '{print $2}')

# Comprobar si la versión es 20.04
if [ "$VERSION" == "20.04" ]; then
    echo "Estás en Ubuntu 20.04. No es necesario realizar la actualización."
else
    echo "Tu versión de Ubuntu no es 20.04. Iniciando la actualización..."
    sudo do-release-upgrade
fi
