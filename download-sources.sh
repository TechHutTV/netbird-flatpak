#!/bin/bash
# Download NetBird sources for offline Flatpak building

set -e

VERSION="0.60.9"
ARCH=$(uname -m)

echo "Downloading NetBird v${VERSION} for ${ARCH}..."

mkdir -p sources

if [ "$ARCH" = "x86_64" ]; then
    echo "Downloading netbird CLI..."
    curl -L "https://github.com/netbirdio/netbird/releases/download/v${VERSION}/netbird_${VERSION}_linux_amd64.tar.gz" \
        -o sources/netbird.tar.gz

    echo "Downloading netbird-ui..."
    curl -L "https://github.com/netbirdio/netbird/releases/download/v${VERSION}/netbird-ui-linux_${VERSION}_linux_amd64.tar.gz" \
        -o sources/netbird-ui.tar.gz
elif [ "$ARCH" = "aarch64" ]; then
    echo "Downloading netbird CLI..."
    curl -L "https://github.com/netbirdio/netbird/releases/download/v${VERSION}/netbird_${VERSION}_linux_arm64.tar.gz" \
        -o sources/netbird.tar.gz

    echo "Downloading netbird-ui..."
    curl -L "https://github.com/netbirdio/netbird/releases/download/v${VERSION}/netbird-ui-linux_${VERSION}_linux_arm64.tar.gz" \
        -o sources/netbird-ui.tar.gz
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Verifying downloads..."
echo "netbird.tar.gz:"
sha256sum sources/netbird.tar.gz

echo "netbird-ui.tar.gz:"
sha256sum sources/netbird-ui.tar.gz

echo ""
echo "Extracting binaries..."
mkdir -p sources/netbird sources/netbird-ui
tar -xzf sources/netbird.tar.gz -C sources/netbird
tar -xzf sources/netbird-ui.tar.gz -C sources/netbird-ui

echo ""
echo "Downloads complete! Files are in sources/"
ls -la sources/netbird/
ls -la sources/netbird-ui/
