#!/bin/bash
sleep 1
# Matamos cualquier proceso congelado
killall -9 xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal

# Intentamos iniciar usando las rutas de Arch Linux / derivadas
if [ -f /usr/lib/xdg-desktop-portal-hyprland ]; then
    /usr/lib/xdg-desktop-portal-hyprland &
    sleep 2
    /usr/lib/xdg-desktop-portal &
# Intentamos iniciar usando las rutas de Fedora / Ubuntu / Debian
elif [ -f /usr/libexec/xdg-desktop-portal-hyprland ]; then
    /usr/libexec/xdg-desktop-portal-hyprland &
    sleep 2
    /usr/libexec/xdg-desktop-portal &
else
    echo "No se encontraron los ejecutables del portal."
fi
