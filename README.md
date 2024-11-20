<p align="center">
<a href=></a><img src="https://i.ibb.co/MsYHgLz/Sin-t-tulo.png"/>
</p>

## Te dejamos el URL Del ISO aqui: (Ubuntu Core 18.04)
```bash
https://www.mediafire.com/file/x2iuy8kq6cobqs7/Ubuntu_Mini%2528x64%2529.iso/file
```
## Te dejamos el URL Del ISO aqui: (Ubuntu Core 24.04)
```bash
https://releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso
```

## Te recuerdo una vez instalado, instalar el comando Git antes de empezar la instalacion
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
```

## Luego de instalar git, sigue las instrucciones abajo:

```bash
sudo git clone https://github.com/mggons93/pi_wireguard.git
cd pi_wireguard/
bash install.sh

```
## Tendras que hacer varias veces la actualizacion de sistema operativo para poderlo usar , para que se ejecute sin problemas tendras que actualizar a una version superior a la 22.04 de ubuntu, si lo vas a usar con una VM requiere como min en disco 30GB y la tarjeta de red debera estar en modo puente.
```bash
cd pi_wireguard/
bash install.sh

```
## El script actualiza de manera manual el sistema operativo Ubuntu core.

## Si tienes un IP estatico deberas colocar la IP en la configuracion de wireguard, en caso de que la ip sea aleatoria deberas usar Duckdns u otro DNS
```bash
Con DuckDNS
environment:
      # ⚠️ Change the server's hostname (clients will connect to):
      - WG_HOST=nombre del dns.duckdns.org

Con IP Estatica
environment:
      # ⚠️ Change the server's hostname (clients will connect to):
      - WG_HOST=Ip estatica

```
## Group
<a href="https://chat.whatsapp.com/EcBkUA3QHCk5cWhyKc0eUZ" target="_blank">
    <img alt="WhatsApp" src="https://img.shields.io/badge/WhatsApp%20Group-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"/>
</a>

### Donate
<a href="https://paypal.me/malagons" target="_blank"><img alt="Paypal" src="https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white" /></a>

