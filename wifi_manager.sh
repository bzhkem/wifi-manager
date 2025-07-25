#!/bin/bash

CONFIG_DIR="/opt/wifi-manager"
KNOWN_NETWORKS="$CONFIG_DIR/known_networks.txt"

mkdir -p "$CONFIG_DIR"
touch "$KNOWN_NETWORKS"

scan_networks() {
    mapfile -t SCANNED < <(nmcli -t -f SSID,SIGNAL dev wifi list | grep -v '^--' | sort -t: -k2 -nr)
}

list_known() {
    echo "Réseaux enregistrés :"
    awk -F'|' '{printf "[%d] SSID: %-30s Auto-connect: %s\n", NR-1, $1, $3}' "$KNOWN_NETWORKS"
}

add_network() {
    ssid="$1"
    password="$2"
    autoconnect="$3"
    grep -q "^$ssid|" "$KNOWN_NETWORKS" || echo "$ssid|$password|$autoconnect" >> "$KNOWN_NETWORKS"
}

manual_connect() {
    scan_networks
    for i in "${!SCANNED[@]}"; do
        ssid=$(echo "${SCANNED[$i]}" | cut -d: -f1)
        signal=$(echo "${SCANNED[$i]}" | cut -d: -f2)
        printf "[%d] SSID: %-30s Signal: %s\n" "$i" "$ssid" "$signal"
    done
    read -p "Choix : " idx
    ssid=$(echo "${SCANNED[$idx]}" | cut -d: -f1)
    read -s -p "Mot de passe pour $ssid : " password
    echo
    nmcli device wifi connect "$ssid" password "$password" && add_network "$ssid" "$password" "yes"
}

forget_network() {
    list_known
    read -p "Numéro du réseau à oublier : " idx
    sed -i "$((idx+1))d" "$KNOWN_NETWORKS"
}

toggle_autoconnect() {
    list_known
    read -p "Numéro du réseau à modifier : " idx
    line=$(sed -n "$((idx+1))p" "$KNOWN_NETWORKS")
    ssid=$(echo "$line" | cut -d'|' -f1)
    password=$(echo "$line" | cut -d'|' -f2)
    current=$(echo "$line" | cut -d'|' -f3)
    new="no"
    [ "$current" = "no" ] && new="yes"
    sed -i "$((idx+1))s/.*/$ssid|$password|$new/" "$KNOWN_NETWORKS"
}

menu() {
    echo "1) Se connecter à un réseau"
    echo "2) Afficher réseaux enregistrés"
    echo "3) Modifier auto-connect"
    echo "4) Oublier un réseau"
    echo "5) Quitter"
    read -p "Choix : " opt
    case "$opt" in
        1) manual_connect ;;
        2) list_known ;;
        3) toggle_autoconnect ;;
        4) forget_network ;;
        *) exit 0 ;;
    esac
}

while true; do
    menu
done
