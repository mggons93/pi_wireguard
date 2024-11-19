#!/bin/bash

# Paso 1: Verificar estado de systemd-resolved
echo "Verificando el estado de systemd-resolved..."
systemctl status systemd-resolved | grep "Active:"

# Si el servicio no está activo, reiniciamos systemd-resolved
if ! systemctl is-active --quiet systemd-resolved; then
    echo "Reiniciando systemd-resolved..."
    sudo systemctl restart systemd-resolved
else
    echo "El servicio systemd-resolved está activo."
fi

# Paso 2: Comprobar si los DNS están configurados correctamente
echo "Verificando la configuración de DNS..."
resolvectl status | grep "DNS Servers"

# Configurar DNS en el caso de que no estén configurados correctamente
echo "Configurando DNS con los servidores de Cloudflare (1.1.1.1 y 1.0.0.1)..."
sudo bash -c 'echo -e "[Resolve]\nDNS=1.1.1.1 1.0.0.1\nFallbackDNS=8.8.8.8 8.8.4.4" > /etc/systemd/resolved.conf'

# Reiniciar el servicio de DNS
sudo systemctl restart systemd-resolved
echo "DNS configurado correctamente."

# Paso 3: Verificar si Docker puede acceder a registry-1.docker.io
echo "Verificando conectividad a Docker Hub..."
nslookup registry-1.docker.io

if [ $? -eq 0 ]; then
    echo "Conectividad con Docker Hub establecida correctamente."
else
    echo "Error de conectividad con Docker Hub. Revisar configuración DNS o la red."
    exit 1
fi

# Paso 4: Verificar configuración de DNS para Docker
echo "Verificando la configuración de DNS de Docker..."
DOCKER_DAEMON_CONFIG="/etc/docker/daemon.json"

# Verificar si el archivo existe
if [ ! -f "$DOCKER_DAEMON_CONFIG" ]; then
    echo "El archivo de configuración de Docker no existe. Creando uno..."
    sudo touch "$DOCKER_DAEMON_CONFIG"
fi

# Añadir o corregir la configuración DNS de Docker
sudo jq '. + {"dns": ["1.1.1.1", "1.0.0.1"]}' "$DOCKER_DAEMON_CONFIG" > "$DOCKER_DAEMON_CONFIG.tmp" && mv "$DOCKER_DAEMON_CONFIG.tmp" "$DOCKER_DAEMON_CONFIG"

# Reiniciar Docker para aplicar la configuración
sudo systemctl restart docker
echo "Configuración DNS de Docker actualizada."

# Paso 5: Comprobar el estado de Docker
echo "Verificando el estado de Docker..."
docker info | grep "Server Version"
