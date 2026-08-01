#!/bin/bash
ALERTA_ENVIADA=0

while true; do
    # Lee el porcentaje y el estado (cargando/descargando) de la batería principal (BAT0)
    # Nota: Si tu batería se llama BAT1, cambia el BAT0 de las siguientes líneas.
    BATERIA=$(cat /sys/class/power_supply/BAT1/capacity)
    ESTADO=$(cat /sys/class/power_supply/BAT1/status)

    if [[ "$BATERIA" -le 20 && "$ESTADO" == "Discharging" ]]; then
        if [[ "$ALERTA_ENVIADA" == 0 ]]; then
            pw-play ~/.local/share/sounds/bateria.wav &
            ALERTA_ENVIADA=1
        fi
    else
        ALERTA_ENVIADA=0
    fi
    
    sleep 30
done
