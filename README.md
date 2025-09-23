# PXE_Setup


Este repositorio contiene un script automatizado para instalar **iVentoy PXE** en Linux.  
El script soporta varias distribuciones, descarga la versión especificada de iVentoy, instala dependencias, configura permisos y crea un **servicio systemd** para facilitar su ejecución.

---

## 📌 Características

- Instalación rápida y automatizada.
- Soporte para:
  - Debian / Ubuntu
  - Alpine Linux
  - RedHat / CentOS / Fedora
- Descarga de la versión deseada desde GitHub.
- Verificación opcional de integridad con **SHA256**.
- Creación de alias para ejecutar `iventoy` desde cualquier lugar.
- Servicio **systemd** para ejecución automática al iniciar el sistema.

---

## 🚀 Instalación

Clona el repositorio:

```bash
git clone https://github.com/JaimeGalvezMartinez/PXE_Setup
cd 
chmod +x PXE_Setup.sh

