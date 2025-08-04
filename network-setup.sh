#!/bin/bash

set -e

# Define variables
DHCPCD_CONF="/etc/dhcpcd.conf"
SERVICE_FILE="/lib/systemd/system/ipv6.service"

# Add static IPv6 config if not already present
if ! grep -q "interface eth0" "$DHCPCD_CONF"; then
    echo "Adding static IPv6 config to $DHCPCD_CONF..."
    cat <<EOF | sudo tee -a "$DHCPCD_CONF" > /dev/null

interface eth0
static ip6_address=fd00::eb:14/64
EOF
else
    echo "Static IPv6 config for eth0 already exists in $DHCPCD_CONF."
fi

# Create the systemd service file
echo "Creating systemd service file at $SERVICE_FILE..."
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Restart dhcpcd service using new file
After=network.target

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 60
ExecStart=/usr/bin/systemctl restart dhcpcd.service
ExecStartPost=/bin/sleep 15
ExecStartPost=/bin/systemctl restart dhcpcd.service
ExecStartPost=/bin/sleep 15
ExecStartPost=/bin/systemctl restart dhcpcd.service
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon and enable service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling ipv6.service..."
sudo systemctl enable ipv6.service

echo "Setup complete! Please reboot your system to apply changes."
