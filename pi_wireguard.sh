# Actualizar resolv.conf con DNS de Google y Cloudflare
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf > /dev/null

# Asegurarse de que los cambios sean persistentes (si estás usando systemd-resolved)
if [ -f "/etc/systemd/resolved.conf" ]; then
    echo "Configurando DNS para systemd-resolved..."
    sudo sed -i 's/#DNS=.*/DNS=8.8.8.8 1.1.1.1/' /etc/systemd/resolved.conf
    sudo systemctl restart systemd-resolved
fi

# Si estás usando NetworkManager, configuramos el DNS para todas las conexiones
if command -v nmcli > /dev/null; then
    echo "Configurando DNS en NetworkManager..."
    sudo nmcli dev show | grep 'IP4.DNS' | cut -d ':' -f2 | while read dns; do
        sudo nmcli con mod "$(nmcli con show --active | head -n 1)" ipv4.dns "8.8.8.8 1.1.1.1"
    done
    sudo systemctl restart NetworkManager
fi

echo "DNS configurado correctamente a 8.8.8.8 y 1.1.1.1"

echo "Reiniciando Servicio DNS"
sudo systemctl restart systemd-resolved

# Actualiza los índices de los paquetes
sudo apt update && sudo apt upgrade -y
# Instala Curl
sudo apt install curl -y
# Instala Git
sudo apt install git -y
# Añadir el repositorio oficial de Docker (si no lo tienes)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Actualizar la lista de paquetes después de añadir el repositorio de Docker
sudo apt update
# Instalar Docker y sus componentes
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#Detener el servicio DNS
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
#Creando directorios
sudo mkdir /home/pihole
sudo mkdir /home/wireguard
cd
cd pi_wireguard/
sudo docker compose up -d
#Completado
