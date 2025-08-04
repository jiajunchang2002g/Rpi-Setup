#!/bin/bash

set -e  # Exit on any error

echo "Updating package lists..."
sudo apt update

echo "Installing vim..."
sudo apt install -y vim

echo "Installing Oh My Bash..."

# Install Oh My Bash unattended (no prompts)
# Using official Oh My Bash installer from GitHub
# Reference: https://github.com/ohmybash/oh-my-bash

# If ~/.oh-my-bash exists, skip install
if [ ! -d "$HOME/.oh-my-bash" ]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Bash already installed."
fi

# Define paths for autostart script
AUTOSTART_DIR="$HOME/.config/autostart"
HELLO_SCRIPT="$HOME/hello_startup.sh"
DESKTOP_FILE="$AUTOSTART_DIR/hello_startup.desktop"

mkdir -p "$AUTOSTART_DIR"

# Create the hello startup script
cat <<EOF > "$HELLO_SCRIPT"
#!/bin/bash
echo "Hello! This script ran at startup on \$(date)" >> \$HOME/hello_log.txt
EOF

# Make it executable but readonly (read + execute, no write)
chmod 555 "$HELLO_SCRIPT"

# Create the .desktop autostart file
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Type=Application
Exec=$HELLO_SCRIPT
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Hello Startup Script
Comment=Prints Hello to a log file at startup
EOF

echo "Setup complete. Vim installed, Oh My Bash installed (or already installed),"
echo "and readonly hello startup script configured for autostart on next login."
