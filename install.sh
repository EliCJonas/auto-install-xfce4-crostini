#!/bin/bash
set -e

echo "Installing Xfce4 desktop environment and Xephyr for ChromeOS..."

# Check if running with sudo capability (non-interactive for Crostini)
if ! sudo -n true 2>/dev/null; then
    echo "Error: This script requires passwordless sudo (standard in Crostini)." >&2
    exit 1
fi

# Check for required commands
if ! command -v wget &> /dev/null; then
    echo "Installing wget..."
    sudo apt install -y wget
fi

sudo apt update
sudo apt install -y xserver-xephyr xfce4 xfce4-goodies

echo "Installation complete."
echo "Testing Xephyr display..."


# Install task-xfce-desktop to pull in additional Xfce4 dependencies, then immediately
# purge it. The meta-package configures XFCE to autostart on container startup, and if
# the user closes XFCE in that state, it crashes the Crostini container.
echo "Now installing additional packages for Xfce4..."
sudo apt install -y task-xfce-desktop

echo "Purging meta-package to prevent autostart issues..."
sudo apt purge -y task-xfce-desktop
sudo apt purge -y libreoffice*
sudo apr purge lightdm

# Create applications directory if it doesn't exist
mkdir -p ~/.local/share/applications

# Base URL for raw GitHub files
BASE_URL="https://raw.githubusercontent.com/EliCJonas/auto-install-xfce4-crostini/a1398852871f6cee3a0d95f50f4adb9b5abcdebe"
BASE_URL2="https://raw.githubusercontent.com/EliCJonas/auto-install-xfce4-crostini/b13005a75f61c5503db1d161bda9534ba469d692"

echo "Downloading start and stop scripts..."
if ! wget -q -O startxfce "$BASE_URL/startxfce"; then
    echo "Error: Failed to download startxfce script." >&2
    exit 1
fi

if ! wget -q -O stopxfce "$BASE_URL/stopxfce"; then
    echo "Error: Failed to download stopxfce script." >&2
    rm -f startxfce
    exit 1
fi

echo "Making scripts executable and moving to /usr/local/bin..."
sudo chmod +x startxfce stopxfce
sudo mv startxfce stopxfce /usr/local/bin/

echo "Downloading .desktop files for easier access..."
if ! wget -q -O StartXFCE.desktop "$BASE_URL/StartXFCE.desktop"; then
    echo "Error: Failed to download StartXFCE.desktop." >&2
    exit 1
fi

if ! wget -q -O StopXFCE.desktop "$BASE_URL2/StopXFCE.desktop"; then
    echo "Error: Failed to download StopXFCE.desktop." >&2
    rm -f StartXFCE.desktop
    exit 1
fi

mv StartXFCE.desktop StopXFCE.desktop ~/.local/share/applications/

echo "Finishing setup with Settings application..."
sudo apt install -y xfce4-settings

if ! wget -q -O XFCESettings.desktop "$BASE_URL2/XFCESettings.desktop"; then
    echo "Error: Failed to download XFCESettings.desktop." >&2
    exit 1
fi

mv XFCESettings.desktop ~/.local/share/applications/

echo "Setup complete! You can now start Xfce4 by clicking the 'Start XFCE' icon in your app launcher or by typing 'startxfce' in the terminal."
