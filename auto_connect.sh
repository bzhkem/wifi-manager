#!/bin/bash

CONFIG_DIR="/opt/wifi-manager"
KNOWN_NETWORKS="$CONFIG_DIR/known_networks.txt"

while true; do
    connected=$(nmcli -t -f STATE g)
    if [ "$connected" != "connected" ]; then
        mapfile -t SCANNED < <(nmcli -t -f SSID dev wifi list | grep -v '^--')
        while IFS='|' read -r ssid pass auto; do
            for s in "${SCANNED[@]}"; do
                if [ "$s" = "$ssid" ] && [ "$auto" = "yes" ]; then
                    nmcli dev wifi connect "$ssid" password "$pass" && break 2
                fi
            done
        done < "$KNOWN_NETWORKS"
    fi
    sleep 10
done
