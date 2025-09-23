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
````
Ejecuta el instalador como root:

```bash
sudo ./install_iventoy.sh
```
Por defecto instalará la versión 1.0.21.

Si además deseas verificar el archivo descargado con su hash SHA256:
```
sudo ./install_iventoy.sh 1.0.22 "abc123def456..."
```
⚙️ Uso

Una vez instalado:
🔹 Ejecución manual
``
iventoy
``

🔹 Servicio systemd

```bash
sudo systemctl start iventoy      # Iniciar servicio
sudo systemctl stop iventoy       # Detener servicio
sudo systemctl restart iventoy    # Reiniciar servicio
sudo systemctl status iventoy     # Ver estado

```
El servicio se habilita automáticamente en cada reinicio:

📝 Notas importantes

# - Necesitas permisos de root para ejecutar el instalador. -

# - En Alpine Linux, iVentoy puede requerir adaptaciones ya que usa openrc en lugar de systemd.

📄 Licencia

Este proyecto se distribuye bajo licencia MIT.

Jaime Galvez Martinez
