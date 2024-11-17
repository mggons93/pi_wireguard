sudo apt update && sudo apt upgrade && sudo apt install git && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
mkdir /home/pihole
mkdir /home/wireguard
mkdir /home/pi-wireguard
cd /home/pi-wireguard
sudo git clone https://raw.githubusercontent.com/mggons93/pi_wireguard/refs/heads/main/docker-compose.yml
sudo docker compose up -d
