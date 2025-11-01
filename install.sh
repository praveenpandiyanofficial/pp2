#!/bin/bash
# install.sh

echo "Installing PP2..."

PP2_URL="https://raw.githubusercontent.com/praveenpandiyanofficial/pp2/main/pp2.sh"
DEST="/usr/local/bin/pp2"

curl -fsSL $PP2_URL -o $DEST
chmod +x $DEST

echo "PP2 installed! You can now run 'pp2' from anywhere."
