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

mkdir /home/pihole
mkdir /home/wireguard
mkdir /home/pi-wireguard
cd /home/pi-wireguard
sudo git clone https://raw.githubusercontent.com/mggons93/pi_wireguard/refs/heads/main/docker-compose.yml
sudo docker compose up -d
