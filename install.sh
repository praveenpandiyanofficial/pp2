#!/bin/bash
# install.sh

echo "Installing PP2..."

# Raw URL of pp2.sh in your GitHub repo
PP2_URL="https://raw.githubusercontent.com/praveenpandiyanofficial/pp2/main/pp2.sh"
DEST="/usr/local/bin/pp2"

# Download pp2.sh
if curl -fsSL "$PP2_URL" -o "$DEST"; then
    chmod +x "$DEST"
    echo "PP2 installed successfully! You can now run 'pp2' from anywhere."
else
    echo "Failed to download pp2.sh from GitHub. Please check the URL."
    exit 1
fi
