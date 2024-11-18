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
