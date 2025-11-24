echo "Reiniciando Servicio DNS"
sudo systemctl restart systemd-resolved

# Actualiza los índices de los paquetes
sudo apt update && sudo apt upgrade -y
# Instala paquetes esenciales
sudo apt install curl git net-tools openssl -y
# ⚠️ Instalar módulos de kernel NECESARIOS para WireGuard e IPv6 NAT
sudo apt install linux-modules-extra-$(uname -r) -y
# Instalar iptables e ip6tables (wg-easy los necesita SIEMPRE)
sudo apt install iptables ip6tables -y
# Instalar wireguard tools solo por seguridad (algunos minimal fallan sin esto)
sudo apt install wireguard-tools -y

echo "Reiniciando módulos del kernel..."
sudo modprobe ip_tables
sudo modprobe ip6_tables
sudo modprobe wireguard

# Añadir el repositorio oficial de Docker (si no lo tienes)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Actualizar la lista de paquetes después de añadir el repositorio de Docker
sudo apt update
# Instalar Docker y sus componentes
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# Creando directorios
sudo mkdir /home/pihole
sudo mkdir /home/wg-easy
sudo mkdir -p /home/wg-easy/ssl
sudo mkdir -p /home/pihole/etc-pihole
sudo mkdir -p /home/pihole/etc-dnsmasq.d
# Carpetas SSL
sudo mkdir -p /home/wg-easy/ssl
sudo chown -R 1000:1000 /home/wg-easy/ssl
# Generar certificados SSL autofirmados para wg-easy
echo "Generando certificados SSL autofirmados para WireGuard..."
SSL_DIR="/home/wg-easy/ssl"
if [ ! -f "$SSL_DIR/cert.pem" ] || [ ! -f "$SSL_DIR/key.pem" ]; then
    sudo openssl req -x509 -newkey rsa:4096 -sha256 -days 365 \
      -nodes \
      -keyout "$SSL_DIR/key.pem" \
      -out "$SSL_DIR/cert.pem" \
      -subj "/CN=wirednssya.duckdns.org"

    sudo chmod 600 "$SSL_DIR/key.pem"
    sudo chmod 644 "$SSL_DIR/cert.pem"

    echo "Certificados SSL creados correctamente."
else
    echo "Los certificados SSL ya existen. No se vuelven a crear."
fi
# Descargando paquetes sin iniciar
sudo docker compose pull
# Detener el servicio DNS
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
# Iniciando Paquetes en desacople
sudo docker compose up -d
# Completado
