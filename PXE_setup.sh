#!/bin/bash

# ==============================
# iVentoy PXE Installer & Service
# ==============================

# Colores para mensajes
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m" # Sin color

# Variables
IVENTOY_VERSION="1.0.19"
INSTALL_DIR="/opt/iventoy"
JSON_FILE="$INSTALL_DIR/iventoy.json"
SERVICE_FILE="/etc/systemd/system/iventoy.service"
DOWNLOAD_URL="https://github.com/ventoy/PXE/releases/download/v$IVENTOY_VERSION/iventoy-$IVENTOY_VERSION-linux-free.tar.gz"

echo -e "${BLUE}🚀 Iniciando instalación de iVentoy PXE...${NC}"

# ------------------------------
# 1️⃣ Detener y limpiar instalación previa y archivos de configuración
# ------------------------------
echo -e "${YELLOW}🔄 Deteniendo y eliminando configuraciones anteriores...${NC}"

if systemctl is-active --quiet iventoy.service; then
    echo -e "${YELLOW}Deteniendo servicio existente...${NC}"
    sudo systemctl stop iventoy.service
fi

if systemctl list-unit-files | grep -q iventoy.service; then
    echo -e "${YELLOW}Deshabilitando servicio existente...${NC}"
    sudo systemctl disable iventoy.service
fi

if [ -f "$SERVICE_FILE" ]; then
    echo -e "${YELLOW}Eliminando archivo de servicio antiguo...${NC}"
    sudo rm -f "$SERVICE_FILE"
fi

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Eliminando instalación anterior y archivos de configuración...${NC}"
    sudo rm -rf "$INSTALL_DIR"
fi

# ------------------------------
# 2️⃣ Crear directorio de instalación
# ------------------------------
echo -e "${BLUE}📂 Creando directorio de instalación: $INSTALL_DIR${NC}"
sudo mkdir -p $INSTALL_DIR
sudo chown $USER:$USER $INSTALL_DIR

# ------------------------------
# 3️⃣ Descargar y extraer iVentoy
# ------------------------------
echo -e "${BLUE}⬇️  Descargando iVentoy versión $IVENTOY_VERSION...${NC}"
wget $DOWNLOAD_URL -O /tmp/iventoy.tar.gz

echo -e "${BLUE}📦 Extrayendo archivos en $INSTALL_DIR...${NC}"
tar -xzf /tmp/iventoy.tar.gz -C $INSTALL_DIR

# ------------------------------
# 4️⃣ Detectar iventoy.sh
# ------------------------------
SCRIPT_PATH=$(find $INSTALL_DIR -name iventoy.sh | head -n1)
if [ -z "$SCRIPT_PATH" ]; then
    echo -e "${RED}❌ Error: No se encontró iventoy.sh después de extraer el tar.${NC}"
    exit 1
fi
chmod +x "$SCRIPT_PATH"
echo -e "${GREEN}✔ Encontrado iventoy.sh en: $SCRIPT_PATH${NC}"

# ------------------------------
# 5️⃣ Crear archivo JSON
# ------------------------------
echo -e "${BLUE}📝 Creando JSON con ruta del ejecutable...${NC}"
cat <<EOF > $JSON_FILE
{
  "path": "$SCRIPT_PATH"
}
EOF
echo -e "${GREEN}✔ JSON creado en $JSON_FILE${NC}"

# ------------------------------
# 6️⃣ Crear servicio systemd
# ------------------------------
echo -e "${BLUE}⚙️  Configurando servicio systemd...${NC}"
sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=iVentoy PXE Service
After=network.target

[Service]
Type=forking
ExecStart=/bin/bash $SCRIPT_PATH start
ExecStop=/bin/bash $SCRIPT_PATH stop
Restart=on-failure
WorkingDirectory=$(dirname $SCRIPT_PATH)
User=root

[Install]
WantedBy=multi-user.target
EOF"

# ------------------------------
# 7️⃣ Habilitar y arrancar servicio
# ------------------------------
echo -e "${BLUE}🚀 Habilitando y arrancando el servicio...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable iventoy.service
sudo systemctl restart iventoy.service

# ------------------------------
# 8️⃣ Verificación rápida
# ------------------------------
echo -e "${GREEN}🎉 iVentoy instalado correctamente en $INSTALL_DIR${NC}"
echo -e "${GREEN}📄 JSON creado en $JSON_FILE${NC}"
echo -e "${GREEN}🔹 Servicio systemd activo: systemctl status iventoy.service${NC}"
echo -e "${GREEN}🔹 Cada vez que se inicie el sistema, iVentoy lo hara automaticamente${NC}"
echo -e "${GREEN}🔹 Para ver la infer Web del PXE, Dirijase a http://x.x.x.x:26000 o localhost:26000${NC}"
