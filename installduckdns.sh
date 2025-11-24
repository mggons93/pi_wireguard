#!/bin/bash

# Mostrar el estado del cron
ps -ef | grep cr[o]n

# Crear carpeta duckdns si no existe
mkdir -p ~/duckdns
cd ~/duckdns

# Crear el script de actualización DuckDNS
sudo bash -c 'cat << EOF > ~/duckdns/duck.sh
#!/bin/sh
TOKEN="TU_TOKEN_AQUI" # Ejemplo TOKEN="b2387hsh238hs238hs23"
DOMAINS="TU_DOMINIO_AQUI"   # Ejemplo: wirednssya
HOST="www.duckdns.org"
PORT="80"

# Construir la petición HTTP
URI="/update?domains=\$DOMAINS&token=\$TOKEN&ip=&verbose=true"

HTTP_QUERY="GET \$URI HTTP/1.1\r
Host: \$HOST\r
Accept: text/html\r
Connection: close\r
\r
"

# Mostrar la consulta para depuración
echo "\$HTTP_QUERY"

# Ejecutar petición usando netcat
(printf "\$HTTP_QUERY" && sleep 5) | nc \$HOST \$PORT

EOF'

# Permisos
chmod 700 ~/duckdns/duck.sh

# Añadir cronjob cada 5 minutos
(crontab -l 2>/dev/null; echo "*/5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1") | crontab -

# Ejecutar una vez para probar
~/duckdns/duck.sh
