# PXE_Setup


Este repositorio contiene un script automatizado para instalar **iVentoy PXE** en Linux.  
El script soporta varias distribuciones, descarga la versión especificada de iVentoy, instala dependencias, configura permisos y crea un **servicio systemd** para facilitar su ejecución.

---

## 📌 Características

- Instalación rápida y automatizada.
- Soporte para:
  - Debian / Ubuntu 16.04 =>
- Descarga de la versión deseada desde GitHub.
- Verificación opcional de integridad con **SHA256**.
- Creación de **systemd** para ejecutar `iventoy` desde cualquier lugar.
- Servicio **systemd** para ejecución automática al iniciar el sistema.

---

## 🚀 Instalación

Clona el repositorio:

```bash
git clone https://github.com/JaimeGalvezMartinez/PXE_Setup
cd PXE_Setup
chmod +x PXE_setup.sh
````
Ejecuta el instalador como root:

```bash
sudo ./PXE_setup.sh
```
Por defecto instalará la versión 1.0.19

⚙️ Uso

Una vez instalado

🔹 Servicio systemd

```bash
sudo systemctl start iventoy      # Iniciar servicio
sudo systemctl stop iventoy       # Detener servicio
sudo systemctl restart iventoy    # Reiniciar servicio
sudo systemctl status iventoy     # Ver estado

```
El servicio se habilita automáticamente en cada reinicio:

📝 Notas importantes

**- Necesitas permisos de root para ejecutar el instalador.-**
<pre></pre>
**- Compatible con Ubuntu 16.04 en adelante.-**

📄 Licencia

Este proyecto se distribuye bajo licencia MIT.

Jaime Galvez Martinez
