# Raspberry Pi Static IP Setup

Configure static IPv4 (`192.168.7.39/24`) and IPv6 (`fd00::eb:14/64`) addresses.

## Steps

1. **Edit dhcpcd config**
```bash
sudo nano /etc/dhcpcd.conf
```
Add:
```
interface eth0
static ip6_address=fd00::eb:14/64
static ip_address=192.168.7.39/24
```

2. **Create service**
```bash
sudo nano /lib/systemd/system/<service-name>.service
```
Add:
```ini
[Unit]
Description=Restart dhcpcd service
After=network.target

Type=oneshot
ExecStartPre=/usr/bin/sleep 60
ExecStart=/usr/bin/systemctl restart dhcpcd
ExecStartPre=/usr/bin/sleep 15
ExecStart=/usr/bin/systemctl restart dhcpcd
ExecStartPre=/usr/bin/sleep 15
ExecStart=/usr/bin/systemctl restart dhcpcd
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

3. **Enable service**
```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable <service-name>.service
sudo reboot
```

## Verify
```bash
ip addr show dev eth0
systemctl status network-restart.service

E.g. 

ip addr show dev eth0 | sed -e 's/192\.168\.7\.39\/24/\x1b[33m&\x1b[0m/g' -e 's/fd00::eb:14\/64/\x1b[33m&\x1b[0m/g'

```

# Install relevant dependencies for demo front-end:

Install required packages (Ubuntu/Debian):
```sh
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev
sudo apt install python3-pyqt5 python3-pyqt5.qtquick python3-pyqt5.qtsvg python3-pyqt5.qtquickcontrols2
sudo apt install qt5dxcb-plugin
sudo apt install qml-module-qtquick-controls qml-module-qtquick-controls2
sudo apt install qml-module-qtquick-dialogs qml-module-qtquick-layouts
sudo apt install qml-module-qtquick-window2 qml-module-qtquick2
sudo apt install qml-module-qtgraphicaleffects qml-module-qtqml-models2
```