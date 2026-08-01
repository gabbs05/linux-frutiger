#!/bin/bash

# 1. Avisar a Hyprland que active la trampa para el ESC
hyprctl dispatch submap rofi_abierto

# 2. Reproducir el sonido de apertura
pw-play ~/.local/share/sounds/rofi.wav &

# 3. Lanzar Rofi (el script se queda congelado aquí hasta que Rofi desaparezca)
rofi -show drun

# 4. Cuando Rofi se cierre (ya sea por abrir una app, hacer clic fuera, o matarlo con ESC),
# el script se descongela y desactiva la trampa automáticamente.
hyprctl dispatch submap reset
