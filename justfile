default:
    @just --list

# Install the theme (interactive)
install:
    sudo ./install_theme.sh

# Regenerate icons into minegrub-world-selection/icons/
icons:
    cd icon-generator && ./gen_icons.sh

# Remove the installed theme (then drop GRUB_THEME and regenerate grub.cfg)
uninstall:
    sudo rm -rf /boot/grub*/themes/minegrub-world-selection
