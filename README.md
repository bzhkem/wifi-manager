# WiFi Manager (CLI)

Gestionnaire de connexions Wi-Fi pour systèmes sans interface graphique.

## Fonctions

- Connexion manuelle à un réseau Wi-Fi
- Sauvegarde des réseaux connus
- Auto-reconnexion si le Wi-Fi est perdu
- Activation/désactivation de la reconnexion automatique
- Suppression d’un réseau connu

## Installation

```bash
sudo -i
cd /opt
git clone https://github.com/bzhkem/wifi-manager.git
cp /opt/wifi-manager/systemd/wifi-manager.service /etc/systemd/system/
chmod +x /opt/wifi-manager/*.sh
systemctl daemon-reload
systemctl enable wifi-manager
systemctl start wifi-manager
sudo /opt/wifi-manager/wifi_manager.sh
```
