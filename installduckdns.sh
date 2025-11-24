#!/bin/bash

# Obtener usuario real (aunque el script se ejecute con sudo)
REAL_USER=$(logname)
REAL_HOME=$(eval echo "~$REAL_USER")

echo "Usuario detectado: $REAL_USER"
echo "Home detectado: $REAL_HOME"

# Mostrar el estado del cron
ps -ef | grep cr[o]n

# Crear carpeta duckdns si no existe
mkdir -p "$REAL_HOME/duckdns"
cd "$REAL_HOME/duckdns"

# Crear duck.sh con el usuario correcto (sin referencias rotas)
cat << EOF > "$REAL_HOME/duckdns/duck.sh"
#!/bin/sh
TOKEN="TU_TOKEN_AQUI"
DOMAINS="TU_DOMINIO_AQUI"
HOST="www.duckdns.org"
PORT="80"

URI="/update?domains=\$DOMAINS&token=\$TOKEN&ip=&verbose=true"

HTTP_QUERY="GET \$URI HTTP/1.1\r
Host: \$HOST\r
Accept: text/html\r
Connection: close\r
\r
"

echo "\$HTTP_QUERY"

(printf "\$HTTP_QUERY" && sleep 5) | nc \$HOST \$PORT
EOF

# Permisos correctos
chmod 700 "$REAL_HOME/duckdns/duck.sh"
chown $REAL_USER:$REAL_USER "$REAL_HOME/duckdns/duck.sh"

# Agregar cronjob cada 5 minutos (para el usuario real)
(crontab -u $REAL_USER -l 2>/dev/null; echo "*/5 * * * * $REAL_HOME/duckdns/duck.sh >/dev/null 2>&1") | crontab -u $REAL_USER -

# Ejecutar una vez para probar
sudo -u $REAL_USER "$REAL_HOME/duckdns/duck.sh"
