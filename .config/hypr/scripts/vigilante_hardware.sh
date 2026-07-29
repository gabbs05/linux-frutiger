#!/bin/bash

# Variables de memoria para no repetir el sonido sin parar
MIC_ACTIVO=0
CAM_ACTIVA=0

while true; do
    # 1. Vigilar Micrófono (Revisa si hay algún programa grabando audio)
    if pactl list source-outputs | grep -q "Source Output"; then
        NUEVO_MIC=1
    else
        NUEVO_MIC=0
    fi

    # 2. Vigilar Cámara (Revisa si algún proceso está usando /dev/video)
    if fuser /dev/video* >/dev/null 2>&1; then
        NUEVO_CAM=1
    else
        NUEVO_CAM=0
    fi

    # 3. Disparar el sonido Frutiger Aero SOLO en el momento que se encienden
    if [[ "$NUEVO_MIC" == 1 && "$MIC_ACTIVO" == 0 ]]; then
        # Suena cuando un programa empieza a escucharte
        pw-play ~/.local/share/sounds/notificacion.wav &
    fi

    if [[ "$NUEVO_CAM" == 1 && "$CAM_ACTIVA" == 0 ]]; then
        # Suena cuando un programa enciende la cámara
        pw-play ~/.local/share/sounds/notificacion.wav &
    fi

    # Actualizar estado
    MIC_ACTIVO=$NUEVO_MIC
    CAM_ACTIVA=$NUEVO_CAM

    # Esperar 2 segundos antes de volver a escanear
    sleep 2
done

