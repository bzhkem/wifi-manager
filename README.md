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
sudo chmod +x /opt/wifi-manager/*.sh
sudo systemctl daemon-reload
sudo systemctl enable wifi-manager
sudo systemctl start wifi-manager
sudo /opt/wifi-manager/wifi_manager.sh
```