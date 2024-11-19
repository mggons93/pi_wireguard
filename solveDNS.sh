#!/bin/bash

# Direcciones DNS a configurar
DNS1="8.8.8.8"
DNS2="8.8.4.4"
DNS3="1.1.1.1"

# Función para configurar DNS usando netplan
configure_netplan() {
    echo "Configurando DNS con netplan..."
    
    # Encontrar el archivo de configuración de netplan
    NETPLAN_FILE=$(ls /etc/netplan/*.yaml | head -n 1)
    
    if [ -z "$NETPLAN_FILE" ]; then
        echo "No se encontró un archivo de configuración de netplan."
        exit 1
    fi

    # Añadir las DNS al archivo de configuración de netplan
    sudo sed -i "/ethernets:/a \ \ \ \ nameservers:\n\ \ \ \ \ \ \ \ addresses:\n\ \ \ \ \ \ \ \ \ - $DNS1\n\ \ \ \ \ \ \ \ \ - $DNS2\n\ \ \ \ \ \ \ \ \ - $DNS3" "$NETPLAN_FILE"
    
    # Aplicar los cambios
    sudo netplan apply
    
    echo "DNS configuradas correctamente con netplan."
}

# Función para configurar DNS usando systemd-resolved
configure_systemd_resolved() {
    echo "Configurando DNS con systemd-resolved..."
    
    # Editar el archivo de configuración de resolved.conf
    sudo sed -i "s/^DNS=.*/DNS=$DNS1 $DNS2 $DNS3/" /etc/systemd/resolved.conf
    
    # Reiniciar el servicio systemd-resolved para aplicar los cambios
    sudo systemctl restart systemd-resolved
    
    echo "DNS configuradas correctamente con systemd-resolved."
}

# Función para configurar DNS en /etc/resolv.conf (solo si no se usa systemd)
configure_resolv_conf() {
    echo "Configurando DNS en /etc/resolv.conf..."

    echo "nameserver $DNS1" | sudo tee /etc/resolv.conf > /dev/null
    echo "nameserver $DNS2" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver $DNS3" | sudo tee -a /etc/resolv.conf > /dev/null

    echo "DNS configuradas correctamente en /etc/resolv.conf."
}

# Comprobar si estamos usando netplan o systemd
if [ -f "/etc/netplan" ]; then
    configure_netplan
elif [ -f "/etc/systemd/resolved.conf" ]; then
    configure_systemd_resolved
else
    # Si no usamos netplan ni systemd, configuramos resolv.conf directamente
    configure_resolv_conf
fi

# Confirmar los cambios
echo "Configuración de DNS completada. Comprobando configuración..."
systemd-resolve --status
