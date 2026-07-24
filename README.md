# linux-frutiger
Configuraciones de Hyprland, Kitty, Dolphin, Rofi y Waybar (en caso de crasheos solo devolver a un commit funcional anterior

# Contexto de mi Entorno de Trabajo Actual

Por favor, lee este resumen para tener el contexto de mi sistema antes de responder a mis siguientes preguntas. No es necesario que confirmes todo el texto, solo dime "Contexto asimilado" y estaré listo para preguntar.

## Entorno Host (Linux)
- **SO:** Fedora 44.
- **Entorno:** Hyprland (Wayland) con estética Frutiger Aero / Windows Vista.
- **Herramientas:** Waybar, Rofi, Kitty, Dolphin.

### Archivos de Configuración Clave y Modificaciones Aplicadas
- **`~/.config/hypr/hyprland.conf`:**
  - *Comportamiento Visual:* Bordes de ventanas con opacidad ajustada a 1.0, gaps configurados en 5 (interno) y 20 (externo), y efecto blur forzado incluso en ventanas transparentes (`ignore_opacity = true`).
  - *Reglas de Ventanas (Window Rules):* Ventanas flotantes forzadas, centradas y con tamaño fijo para diálogos nativos de GTK, selectores de archivos, gestor Bluetooth y `virt-manager`.
  - *Estética Aero Glass para Selector de Pantallas:* Se añadieron reglas específicas para la utilidad `hyprland-share-picker`, dándole un aspecto cristalino mediante opacidad, difuminado y bordes brillantes:
    ```conf
    windowrulev2 = opacity 0.85 0.85,class:^(hyprland-share-picker)$
    windowrulev2 = blur,class:^(hyprland-share-picker)$windowrulev2 = bordersize 2,class:^(hyprland-share-picker)$
    windowrulev2 = bordercolor rgb(ffffff) rgb(7cb8eb) 45deg,class:^(hyprland-share-picker)$windowrulev2 = rounding 8,class:^(hyprland-share-picker)$
    ```
  - *Arranque Automático (Autostart):* Gestión del wallpaper mediante `swaybg` e inicialización de los portales de escritorio saltándose Systemd usando `exec-once = ~/.config/hypr/scripts/portals.sh`.

- **`~/.config/hypr/scripts/portals.sh`:**
  - Script Bash creado manualmente para solucionar el bloqueo de captura de pantalla por fallo de dependencia de `graphical-session.target`. Mata los procesos colgados y arranca los binarios de `xdg-desktop-portal` en segundo plano nativo.

- **`~/.config/wireplumber/wireplumber.conf.d/50-bluetooth-policy.conf`:**
  - Política de audio personalizada creada para forzar el cambio automático (Auto-Switch) del perfil Bluetooth A2DP (Alta Fidelidad) a HSP/HFP (Llamadas), permitiendo que aplicaciones WebRTC (como Google Meet) puedan detectar y capturar el micrófono de dispositivos como los JBL TUNE 710BT sin intervención manual.

## Entorno Guest (Máquina Virtual)
- **Hipervisor:** QEMU/KVM gestionado mediante `virt-manager`.
- **SO Virtual:** Windows 10 Enterprise LTSB 2016 (MiniOS v2024.09).
- **Configuración de Hardware Virtual:** 
  - CPU configurada como `host-passthrough` para máximo rendimiento.
  - Controlador de video cambiado de QXL a `Virtio` para permitir el redimensionamiento dinámico de pantalla.
  - Integración completa con *Spice Guest Tools* (portapapeles compartido funcionando).
  - Transferencia de archivos establecida mediante inyección física de Dispositivo USB Anfitrión (Pendrive).

## Software Instalado y Configurado en la VM
- **Sistema:** Windows activado vía KMS público.
- **Utilidades:** 7-Zip y SumatraPDF (instalados para evitar el peso de Acrobat).
- **Software Principal:** Proteus 8 Professional instalado con licencia local. Configurado en modo "Ejecutar como Administrador" por defecto para evitar crasheos al compilar simulaciones.

## Estado Actual
El entorno está listo para comenzar a simular circuitos electrónicos, extraer archivos de proyectos `.pdsprj` desde mi Drive y diseñar PCBs.

# Guía de Instalación: Fedora Hyprland + Lab Virtual Windows 10 MiniOS

Esta es la bitácora paso a paso de la construcción del entorno de trabajo y simulación electrónica.

## FASE 1: Host Linux (Fedora + Hyprland)
1. Instalación base de Fedora 44.
2. Configuración de Hyprland. Se ajustaron reglas visuales específicas:
   - Bordes de ventanas con opacidad ajustada a 1.0.
   - Gaps configurados en 5 (interno) y 20 (externo).
   - Efecto *blur* activado y forzado incluso en ventanas transparentes (`ignore_opacity = true`).
   - Wallpaper estilo Windows Vista gestionado mediante `swaybg`.
3. Reglas de ventanas flotantes (`windowrulev2`) aplicadas a diálogos nativos de GTK, selectores de archivos, gestor Bluetooth y `virt-manager` para que abran centrados y con tamaño fijo.

## FASE 2: Preparación de la Virtualización
1. Instalación de paquetes de QEMU/KVM y `virt-manager`.
2. Creación de la VM con la ISO de Windows 10 MiniOS LTSB 2016.
3. Instalación de *Spice Guest Tools* en el Guest para habilitar portapapeles compartido.
4. Ajuste de CPU a `host-passthrough` para no perder rendimiento al simular circuitos.

## FASE 3: Solución de Problemas (Troubleshooting)

### Entorno Guest (Máquina Virtual)

**Problema 1: Error de Activación 0x8007007B en Windows LTSB**
- *Causa:* El sistema buscaba un servidor KMS corporativo.
- *Solución:* Ejecutar en CMD como administrador:
  `slmgr /skms kms8.msguides.com` seguido de `slmgr /ato`.

**Problema 2: Pantalla de la VM no redimensionable**
- *Causa:* Conflicto del sistema con el controlador de video por defecto QXL.
- *Solución:* Apagar la VM, ir a los detalles de hardware en `virt-manager`, cambiar el modelo de Video de QXL a **Virtio** y reiniciar.

**Problema 3: Fedora "secuestra" el Pendrive impidiendo inyectarlo a la VM**
- *Causa:* Desmontar por software en Linux suspende lógicamente el dispositivo USB, volviéndolo invisible para `virt-manager`.
- *Solución:* Desconectar y reconectar físicamente el USB. Dejarlo montado en Fedora e inyectarlo directamente desde la opción "Añadir hardware -> Dispositivo USB anfitrión" en virt-manager.

**Problema 4: PowerShell falla al descargar por internet (Errores SSL/TLS)**
- *Causa:* Windows 10 2016 trae comandos antiguos y bloquea TLS 1.2 por defecto. `curl` nativo tampoco existe en esta versión.
- *Solución:* Descargar instaladores (SumatraPDF, 7-Zip, Proteus) directamente en el host Linux y transferirlos al MiniOS usando el método del Pendrive (Solución 3).

**Problema 5: Proteus 8 crashea al intentar correr una simulación**
- *Causa:* El motor ISIS de Proteus requiere acceso profundo al sistema para crear archivos temporales de compilación.
- *Solución:* Ir a las propiedades del acceso directo de Proteus -> Compatibilidad -> Marcar "Ejecutar este programa como administrador" permanentemente.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Entorno Host (Linux / Hyprland)

**Problema 6: Error al compartir pantalla en aplicaciones WebRTC (`xdg-desktop-portal`)**
- *Causa:* Hyprland no notifica correctamente el inicio gráfico a Systemd (`graphical-session.target` inactivo). Esto provoca un fallo de dependencia que bloquea la ejecución de los portales de captura de pantalla.
- *Solución:* Ejecutar un script para saltarse el control de Systemd.
  
  1. Crear el script en `~/.config/hypr/scripts/portals.sh`:
  ```bash
  #!/bin/bash
  sleep 1
  # Matamos cualquier proceso congelado
  killall -9 xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal

  # Detección de binarios según la distribución (Fedora usa libexec)
  if [ -f /usr/libexec/xdg-desktop-portal-hyprland ]; then
      /usr/libexec/xdg-desktop-portal-hyprland &
      sleep 2
      /usr/libexec/xdg-desktop-portal &
  elif [ -f /usr/lib/xdg-desktop-portal-hyprland ]; then
      /usr/lib/xdg-desktop-portal-hyprland &
      sleep 2
      /usr/lib/xdg-desktop-portal &
  fi
  ```
  
  2. Dar permisos de ejecución:
  ```bash
  chmod +x ~/.config/hypr/scripts/portals.sh
  ```
  
  3. Modificar `~/.config/hypr/hyprland.conf` para arrancarlo automáticamente:
  ```conf
  exec-once = ~/.config/hypr/scripts/portals.sh
  ```

**Problema 7: Micrófono de Audífonos Bluetooth (ej. JBL TUNE 710BT) no detectado**
- *Causa:* WirePlumber (el gestor de sesión de PipeWire) retiene de manera agresiva el perfil de Alta Fidelidad (A2DP). Si una aplicación (como Firefox/Meet) no captura el micrófono al instante, el sistema desactiva el perfil de llamadas (HSP/HFP), ocultando el micrófono de las opciones.

- *Solución Rápida (Forzar por consola):*
  Asignar permanentemente el ID estático (Dirección MAC) del micrófono Bluetooth como predeterminado:
  ```bash
  wpctl set-default bluez_input.84:D3:52:A4:13:20
  ```

- *Mejora Propuesta (Solución Definitiva - Automatizada):*
  Activar la conmutación automática de perfiles en WirePlumber.
  
  1. Crear el directorio y archivo de política Bluetooth:
  ```bash
  mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
  nano ~/.config/wireplumber/wireplumber.conf.d/50-bluetooth-policy.conf
  ```
  
  2. Pegar la regla de Auto-Switch:
  ```conf
  wireplumber.settings = {
      bluetooth.autoswitch-to-headset-profile = true
  }
  ```
  
  3. Reiniciar los servicios de audio de usuario:
  ```bash
  systemctl --user restart pipewire wireplumber
  ```
