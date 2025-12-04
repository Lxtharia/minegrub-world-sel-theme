#!/bin/bash

# requires to be run as root, unless the user has access to the theme folder
if [[ `id -u` -ne 0 ]] ; then
	echo "Must be run as root!"
	exit
fi 

# this should be the directory of the clones repo
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# I accidentally deleted the above line once and it copied / into the theme folder, so lets prevent this
if [[ -z $SCRIPT_DIR ]] ; then echo "Something didn't work, exiting"; exit; fi

# check if the grub folder is called grub/ or grub2/
if [ -d /boot/grub ]    ; then
	grub_path="/boot/grub"
elif [ -d /boot/grub2 ] ; then
	grub_path="/boot/grub2"
else 
	echo "Can't find a /boot/grub or /boot/grub2 folder. Exiting."
	exit 
fi
theme_path="$grub_path/themes/minegrub-world-select"


## Prompts

read -p "[?] Copy/Update the theme to '$theme_path'? [Y/n] " -en 1 copy_theme
if [[ "$copy_theme" =~ y|Y || -z "$copy_theme" ]]; then
    echo "[INFO] => Copying the theme files to boot partition:"
    # copy recursive, update, verbose
    cd $SCRIPT_DIR && cp -ruv ./minegrub-world-selection  "$grub_path/themes/" | awk '$0 !~ /skipped/ { print "\t"$0 }'
else
    echo "[INFO] [Skipping] Copying the theme files to boot partition"
fi


need_run_mkconfig=false

echo
read -p "[?] Apply patch to be able to set the grub-consoles background with GRUB_BACKGROUND? [y/N] " -e skip_patch_background
if [[ "$skip_patch_background" =~ y|Y ]]; then
    need_run_mkconfig=true
    echo "[INFO] Editing /etc/grub.d/00_header"
    # Backing up that file, just in case
    cp --no-clobber /etc/grub.d/00_header ./00_header.bak
    # sed'ing that one line
    sed --in-place -E 's/(.*)elif(.*"x\$GRUB_BACKGROUND" != x ] && [ -f "\$GRUB_BACKGROUND" ].*)/\1fi; if\2/' /etc/grub.d/00_header
else
    echo "[INFO] [Skipping] Editing grub drop-in-config file"
fi


echo
read -p "[?] Apply patch to show icon for the UEFI entry [y/N] " -e skip_patch_uefi
if [[ "$skip_patch_uefi" =~ y|Y ]]; then
    need_run_mkconfig=true
    echo "[INFO] Editing '/etc/grub.d/30_uefi-firmware'"
    # Backing up that file, just in case
    cp --no-clobber /etc/grub.d/30_uefi-firmware ./30_uefi-firmware.bak
    # sed'ing that one line
    sed --in-place -E '/--class uefi/!s#(menuentry '\''\$LABEL'\'')(.*)$#\1 --class uefi \2#' /etc/grub.d/30_uefi-firmware
else
    echo "[INFO] [Skipping] Editing grub drop-in config-file"
fi

echo
read -p "[?] Apply patch to show icons for 'Advanced options' entry [y/N] " -e skip_patch
if [[ "$skip_patch" =~ y|Y ]]; then
    need_run_mkconfig=true
    echo "[INFO] Editing '/etc/grub.d/10_linux'"
    # Backing up that file, just in case
    cp --no-clobber /etc/grub.d/10_linux ./10_linux.bak
    # sed'ing that one line
    sed --in-place -E '/--class submenu/!s#(gettext_printf "Advanced options for %s" "\$\{OS\}" \| grub_quote\)'\'' )\s*(.*)$#\1 --class submenu \2#' /etc/grub.d/10_linux
else
    echo "[INFO] [Skipping] Editing grub drop-in config-file"
fi

mkconfig_cmd=grub-mkconfig
echo
echo "======= Done! ======="
echo "Make sure to add/change this line in /etc/default/grub ..."
echo -e "    GRUB_THEME=$theme_path/theme.txt"
echo "...and run '$mkconfig_cmd -o $grub_path/grub.cfg'" 
if [[ "$need_run_mkconfig" == "true" ]]; then
    read -p "[!] Run $mkconfig_cmd now? [Y/n] " -en 1 mkconfig
    if [[ "$mkconfig" =~ y|Y || -z "$mkconfig" ]]; then
        $mkconfig_cmd -o "$grub_path/grub.cfg"
    fi
fi

