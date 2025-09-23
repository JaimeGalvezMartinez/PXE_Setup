#!/bin/bash

# ================================
# Instalador automático de iVentoy
# Con soporte systemd
# ================================

# Versión configurable (por defecto 1.0.21)
IVENTOY_VERSION="${1:-1.0.21}"

# (Opcional) SHA256 esperado como segundo argumento
EXPECTED_HASH="${2}"

# URL de descarga
URL="https://github.com/ventoy/PXE/releases/download/v${IVENTOY_VERSION}/iventoy-${IVENTOY_VERSION}-linux-free.tar.gz"

# Directorio de instalación
INSTALL_DIR="/opt/iventoy"

# Colores
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Este script necesita permisos de superusuario (root).${RESET}"
    exit 1
fi

# Detectar gestor de paquetes
if [ -f /etc/debian_version ]; then
    PACKAGE_MANAGER="apt-get"
    INSTALL_DEPENDENCIES="wget tar"
elif [ -f /etc/alpine-release ]; then
    PACKAGE_MANAGER="apk"
    INSTALL_DEPENDENCIES="wget tar"
elif [ -f /etc/redhat-release ]; then
    PACKAGE_MANAGER="yum"
    INSTALL_DEPENDENCIES="wget tar"
else
    echo -e "${RED}Sistema operativo no soportado.${RESET}"
    exit 1
fi

# Instalar dependencias
echo -e "${YELLOW}Instalando dependencias necesarias...${RESET}"
if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
    apt-get update && apt-get install -y $INSTALL_DEPENDENCIES
elif [ "$PACKAGE_MANAGER" == "apk" ]; then
    apk update && apk add $INSTALL_DEPENDENCIES
elif [ "$PACKAGE_MANAGER" == "yum" ]; then
    yum install -y $INSTALL_DEPENDENCIES
fi

# Crear directorio
echo -e "${YELLOW}Creando directorio de instalación en ${INSTALL_DIR}...${RESET}"
mkdir -p ${INSTALL_DIR}

# Descargar
echo -e "${YELLOW}Descargando Ventoy PXE ${IVENTOY_VERSION}...${RESET}"
wget -q --show-progress ${URL} -O /tmp/iventoy-${IVENTOY_VERSION}.tar.gz
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: La descarga falló.${RESET}"
    exit 1
fi

# Verificar hash si se proporcionó
if [ -n "$EXPECTED_HASH" ]; then
    echo -e "${YELLOW}Verificando integridad del archivo...${RESET}"
    FILE_HASH=$(sha256sum /tmp/iventoy-${IVENTOY_VERSION}.tar.gz | awk '{print $1}')
    if [ "$FILE_HASH" != "$EXPECTED_HASH" ]; then
        echo -e "${RED}Error: El hash no coincide.${RESET}"
        echo "Esperado: $EXPECTED_HASH"
        echo "Obtenido: $FILE_HASH"
        exit 1
    else
        echo -e "${GREEN}Hash verificado correctamente.${RESET}"
    fi
fi

# Descomprimir
echo -e "${YELLOW}Descomprimiendo el archivo...${RESET}"
tar -xzf /tmp/iventoy-${IVENTOY_VERSION}.tar.gz -C ${INSTALL_DIR}
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: No se pudo descomprimir el archivo.${RESET}"
    exit 1
fi

# Limpiar
rm /tmp/iventoy-${IVENTOY_VERSION}.tar.gz

# Permisos
chown -R root:root ${INSTALL_DIR}
chmod -R 755 ${INSTALL_DIR}

# Alias para ejecutar fácilmente
ln -sf ${INSTALL_DIR}/iventoy /usr/local/bin/iventoy

# Crear servicio systemd
SERVICE_FILE="/etc/systemd/system/iventoy.service"
echo -e "${YELLOW}Creando servicio systemd en ${SERVICE_FILE}...${RESET}"

cat > $SERVICE_FILE <<EOF
[Unit]
Description=iVentoy PXE Service
After=network.target

[Service]
Type=simple
ExecStart=${INSTALL_DIR}/iventoy -c ${INSTALL_DIR}/config/iventoy.json
WorkingDirectory=${INSTALL_DIR}
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Recargar systemd
systemctl daemon-reload
systemctl enable iventoy.service

# Confirmación
echo -e "${GREEN}Instalación completa de Ventoy PXE ${IVENTOY_VERSION}.${RESET}"
echo "Directorio: ${INSTALL_DIR}"
echo "Ejecuta manualmente con: iventoy"
echo "Servicio systemd creado: iventoy.service"
echo
echo "👉 Comandos útiles:"
echo "  systemctl start iventoy    # Iniciar servicio"
echo "  systemctl stop iventoy     # Detener servicio"
echo "  systemctl status iventoy   # Ver estado"
echo "  journalctl -u iventoy -f   # Ver logs en tiempo real"
