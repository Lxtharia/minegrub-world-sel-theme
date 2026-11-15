default:
    @just --list

# Install the theme (interactive)
install:
    sudo ./install_theme.sh

# Regenerate icons into minegrub-world-selection/icons/
icons:
    cd icon-generator && ./gen_icons.sh

# Build the Nix flake
check:
    nix flake check

# Remove the installed theme (run mkconfig afterwards)
uninstall:
    #!/usr/bin/env bash
    set -eu
    dir=$(ls -d /boot/grub*/themes/minegrub-world-selection)
    sudo rm -rf "$dir"
    echo "Removed $dir. Remove GRUB_THEME from /etc/default/grub and run grub-mkconfig."
