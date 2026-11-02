#!/bin/bash

# Lee la capacidad de la batería y el estado (Cargando / Descargando)
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT*/capacity)
BATTERY_STATUS=$(cat /sys/class/power_supply/BAT*/status)

# Si la batería baja de 20 y no está enchufada, avisa.
if [ "$BATTERY_LEVEL" -le 20 ] && [ "$BATTERY_STATUS" = "Discharging" ]; then
    notify-send -u critical "Batería Baja" "El nivel de carga está al ${BATTERY_LEVEL}%. ¡Conecta el cargador!" -i battery-empty
fi
