#!/bin/bash

# PP2 installer

PP2_URL="https://raw.githubusercontent.com/praveenpandiyanofficial/pp2/main/pp2.sh"
INSTALL_PATH="/usr/local/bin/pp2"

echo "Installing PP2..."

# Download pp2.sh
curl -fsSL $PP2_URL -o /tmp/pp2.sh
if [ $? -ne 0 ]; then
    echo "Failed to download pp2.sh from GitHub."
    exit 1
fi

# Move to /usr/local/bin and make executable
sudo mv /tmp/pp2.sh $INSTALL_PATH
sudo chmod +x $INSTALL_PATH

echo "PP2 installed successfully! You can now use it with the command: pp2"
