#!/bin/bash

# Lee el archivo exacto de nwg-look
CURSOR_THEME=$(grep 'gtk-cursor-theme-name' ~/.config/gtk-3.0/settings.ini | cut -d'=' -f2)
CURSOR_SIZE=$(grep 'gtk-cursor-theme-size' ~/.config/gtk-3.0/settings.ini | cut -d'=' -f2)

# Aplica el cursor en vivo
hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE"

# Escribe las variables de entorno en un archivo nativo para el próximo inicio
echo "env = XCURSOR_THEME,$CURSOR_THEME" > ~/.config/hypr/cursor.conf
echo "env = XCURSOR_SIZE,$CURSOR_SIZE" >> ~/.config/hypr/cursor.conf
echo "env = HYPRCURSOR_THEME,$CURSOR_THEME" >> ~/.config/hypr/cursor.conf
echo "env = HYPRCURSOR_SIZE,$CURSOR_SIZE" >> ~/.config/hypr/cursor.conf
