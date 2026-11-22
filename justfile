default:
    @just --list

# Install the theme non-interactively and regenerate grub.cfg
install:
    sudo ./install_theme.sh --yes
    sudo sh -c 'if [ -d /boot/grub ]; then grub-mkconfig -o /boot/grub/grub.cfg; else grub2-mkconfig -o /boot/grub2/grub.cfg; fi'

# Regenerate icons into minegrub-world-selection/icons/
icons:
    cd icon-generator && ./gen_icons.sh

# Remove the installed theme, comment out GRUB_THEME and regenerate grub.cfg
uninstall:
    #!/usr/bin/env bash
    set -eu
    sudo rm -rf /boot/grub*/themes/minegrub-world-selection
    sudo sed -i 's/^GRUB_THEME=/#GRUB_THEME=/' /etc/default/grub
    if [ -d /boot/grub ]; then sudo grub-mkconfig -o /boot/grub/grub.cfg; else sudo grub2-mkconfig -o /boot/grub2/grub.cfg; fi
