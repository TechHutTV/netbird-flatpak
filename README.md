# NetBird Flatpak

Flatpak packaging for [NetBird](https://netbird.io/) - a secure WireGuard-based overlay network client.

## About NetBird

NetBird creates a WireGuard-based overlay network that automatically connects your machines over an encrypted tunnel, leaving behind the hassle of opening ports, complex firewall rules, VPN gateways, and so forth.

Key features:
- Automatic peer-to-peer WireGuard connections
- SSO/MFA integration with Identity Providers
- Granular access control policies
- Network Routes for accessing remote resources
- DNS management for private domains
- Cross-platform support

## Prerequisites

### Install Flatpak and flatpak-builder

**Fedora/RHEL/CentOS:**
```bash
sudo dnf install flatpak flatpak-builder
```

**Ubuntu/Debian:**
```bash
sudo apt install flatpak flatpak-builder
```

**Arch Linux:**
```bash
sudo pacman -S flatpak flatpak-builder
```

### Add Flathub Repository

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Install Required Runtime and SDK

```bash
flatpak install flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08
```

## Building the Flatpak

### Clone this repository

```bash
git clone https://github.com/TechHutTV/netbird-flatpak.git
cd netbird-flatpak
```

### Build and install locally

```bash
# Build the Flatpak
flatpak-builder --force-clean build-dir io.netbird.Client.yml

# Install to user directory
flatpak-builder --user --install --force-clean build-dir io.netbird.Client.yml
```

### Build for a specific architecture

```bash
# For x86_64
flatpak-builder --arch=x86_64 --force-clean build-dir io.netbird.Client.yml

# For ARM64/aarch64
flatpak-builder --arch=aarch64 --force-clean build-dir io.netbird.Client.yml
```

### Create a distributable bundle

```bash
# Build and export to a repository
flatpak-builder --repo=repo --force-clean build-dir io.netbird.Client.yml

# Create a single-file bundle
flatpak build-bundle repo netbird.flatpak io.netbird.Client
```

## Running the Application

After installation, you can run NetBird from your application menu or via command line:

```bash
# Run the UI
flatpak run io.netbird.Client

# Run the CLI
flatpak run --command=netbird io.netbird.Client status
```

## Important Notes

### System Service Requirement

**NetBird requires a system-level daemon for full VPN functionality.** The Flatpak package provides the user interface (netbird-ui) and CLI tools, but the actual VPN tunnel creation requires privileges that must run outside the Flatpak sandbox.

For full functionality, you need to install the NetBird daemon on your host system:

```bash
# Using the official install script
curl -fsSL https://pkgs.netbird.io/install.sh | sh

# Or on Fedora/RHEL with DNF
sudo dnf install netbird

# Or on Ubuntu/Debian with APT
sudo apt install netbird
```

The Flatpak client will communicate with the system daemon to manage your VPN connections.

### Sandbox Permissions

This Flatpak requests the following permissions:

| Permission | Reason |
|------------|--------|
| `--share=network` | Required for VPN network access |
| `--socket=x11` | X11 display for the UI |
| `--socket=wayland` | Wayland display support |
| `--device=all` | Access to TUN device for VPN tunnel |
| `--system-talk-name=io.netbird.daemon` | Communication with system daemon |
| `--filesystem=~/.config/netbird` | User configuration storage |
| `--filesystem=/etc/netbird:ro` | Read system configuration |

### Immutable Distributions

For immutable distributions like Fedora Silverblue, openSUSE MicroOS, or NixOS:

1. Install the NetBird daemon via rpm-ostree, Nix, or your system's package manager
2. Enable and start the netbird service
3. Install this Flatpak for the user interface

**Fedora Silverblue example:**
```bash
# Layer the daemon package
rpm-ostree install netbird
systemctl reboot

# After reboot, enable the service
sudo systemctl enable --now netbird

# Install the Flatpak UI
flatpak install io.netbird.Client
```

## Updating

### Update the Flatpak

```bash
flatpak update io.netbird.Client
```

### Update to a New NetBird Version

To update this Flatpak to a newer NetBird version:

1. Update the version number and URLs in `io.netbird.Client.yml`
2. Download the new release tarballs and calculate SHA256 checksums:
   ```bash
   curl -sL "https://github.com/netbirdio/netbird/releases/download/vX.X.X/netbird_X.X.X_linux_amd64.tar.gz" | sha256sum
   curl -sL "https://github.com/netbirdio/netbird/releases/download/vX.X.X/netbird-ui-linux_X.X.X_linux_amd64.tar.gz" | sha256sum
   ```
3. Update the checksums in the manifest
4. Update the release information in `io.netbird.Client.metainfo.xml`
5. Rebuild the Flatpak

## Development

### Validate AppStream Metadata

```bash
flatpak run org.freedesktop.appstream-glib validate io.netbird.Client.metainfo.xml
```

### Test the Build

```bash
# Build without installing
flatpak-builder --force-clean build-dir io.netbird.Client.yml

# Run from the build directory
flatpak-builder --run build-dir io.netbird.Client.yml netbird-ui
```

## File Structure

```
netbird-flatpak/
├── io.netbird.Client.yml          # Main Flatpak manifest
├── io.netbird.Client.desktop      # Desktop entry file
├── io.netbird.Client.metainfo.xml # AppStream metadata
├── icons/
│   ├── netbird-icon-256.png       # PNG icon (256x256)
│   └── netbird-icon.svg           # SVG icon
└── README.md                       # This file
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This Flatpak packaging is provided under the BSD-3-Clause license, matching the NetBird project license.

## Links

- [NetBird Website](https://netbird.io/)
- [NetBird Documentation](https://docs.netbird.io/)
- [NetBird GitHub Repository](https://github.com/netbirdio/netbird)
- [Flatpak Documentation](https://docs.flatpak.org/)
- [Related Issue: Packaging as a Flatpak](https://github.com/netbirdio/netbird/issues/1038)
