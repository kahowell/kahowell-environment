#!/bin/bash
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat ~/.config/kde_menu_config.js)"
exit 0
