#!/bin/bash

# requires to be run as root, unless the user has access to the theme folder
if [[ `id -u` -ne 0 ]] ; then
	echo "Must be run as root!"
	exit
fi 

# Options: -y/--yes answers every prompt with its default (copy the theme, no patches, no grub-mkconfig)
#          --patch-background, --patch-uefi, --patch-submenu apply the matching patch
YES=false; FORCE_BG=false; FORCE_UEFI=false; FORCE_SUBMENU=false
for arg in "$@"; do
    case "$arg" in
        -y|--yes) YES=true ;;
        --patch-background) FORCE_BG=true ;;
        --patch-uefi) FORCE_UEFI=true ;;
        --patch-submenu) FORCE_SUBMENU=true ;;
        *) echo "Usage: $0 [-y|--yes] [--patch-background] [--patch-uefi] [--patch-submenu]"; exit 1 ;;
    esac
done

# ask "<prompt>" <default y|n> [force]; returns 0 for yes
ask () {
    [[ "$3" == true ]] && return 0
    if [[ "$YES" == true ]]; then [[ "$2" == y ]]; return; fi
    read -p "$1" -e answer
    [[ -z "$answer" ]] && answer="$2"
    [[ "$answer" =~ y|Y ]]
}

# this should be the directory of the clones repo
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# I accidentally deleted the above line once and it copied / into the theme folder, so lets prevent this
if [[ -z $SCRIPT_DIR ]] ; then echo "Something didn't work, exiting"; exit; fi

# check if the grub folder is called grub/ or grub2/
if [ -d /boot/grub ]    ; then
	grub_path="/boot/grub"
    grub_prefix="grub"
elif [ -d /boot/grub2 ] ; then
	grub_path="/boot/grub2"
    grub_prefix="grub2"
else 
	echo "Can't find a /boot/grub or /boot/grub2 folder. Exiting."
	exit 
fi
theme_path="$grub_path/themes/minegrub-world-selection"


## Prompts

if ask "[?] Copy/Update the theme to '$theme_path'? [Y/n] " y; then
    echo "[INFO] => Copying the theme files to boot partition:"
    # copy recursive, update, verbose
    mkdir -p "$theme_path"
    cd $SCRIPT_DIR && cp -ruv ./minegrub-world-selection  "$grub_path/themes/" | awk '$0 !~ /skipped/ { print "\t"$0 }'
else
    echo "[INFO] [Skipping] Copying the theme files to boot partition"
fi

need_run_mkconfig=false

echo
if ask "[?] Apply patch to be able to set the grub-consoles background with GRUB_BACKGROUND? [y/N] " n $FORCE_BG; then
    need_run_mkconfig=true
    echo "[INFO] Editing /etc/grub.d/00_header"
    # Backing up that file, just in case
    cp --no-clobber /etc/grub.d/00_header ./00_header.bak
    # Patching that one line in 00_header
    sed --in-place -E 's/(.*)elif(.*"x\$GRUB_BACKGROUND" != x ] && [ -f "\$GRUB_BACKGROUND" ].*)/\1fi; if\2/' /etc/grub.d/00_header \
        && bg_patch_applied=true
    # change grub configuration
    echo "[INFO] Editing /etc/default/grub"
    sed -i "/^GRUB_BACKGROUND=/d" /etc/default/grub
    echo -e  "GRUB_BACKGROUND=$theme_path/dirt.png" >> /etc/default/grub
else
    echo "[INFO] [Skipping] Editing grub drop-in-config file."
    echo "[INFO] Removing 'GRUB_BACKGROUND' from /etc/default/grub"
    sed -i "/^GRUB_BACKGROUND=/d" /etc/default/grub
fi


echo
if ask "[?] Apply patch to show icon for the UEFI entry [y/N] " n $FORCE_UEFI; then
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
if ask "[?] Apply patch to show icons for 'Advanced options' entry [y/N] " n $FORCE_SUBMENU; then
    need_run_mkconfig=true
    echo "[INFO] Editing '/etc/grub.d/10_linux'"
    # Backing up that file, just in case
    cp --no-clobber /etc/grub.d/10_linux ./10_linux.bak
    # sed'ing that one line
    sed --in-place -E '/--class submenu/!s#(gettext_printf "Advanced options for %s" "\$\{OS\}" \| grub_quote\)'\'' )\s*(.*)$#\1 --class submenu \2#' /etc/grub.d/10_linux
else
    echo "[INFO] [Skipping] Editing grub drop-in config-file"
fi


if [ ! -d "$theme_path" ]; then 
    echo "[WARN] The theme wasn't installed. Try to run the script again. Exiting."
    exit 0
fi

echo
sleep 0.5 # Just for fun
echo "[INFO] Setting theme in /etc/default/grub"
sed -i "/^GRUB_TIMEOUT_STYLE=/d" /etc/default/grub
sed -i "/^GRUB_THEME=/d"         /etc/default/grub
echo -e "GRUB_TIMEOUT_STYLE=menu"          >> /etc/default/grub
echo -e "GRUB_THEME=$theme_path/theme.txt" >> /etc/default/grub
sleep 1

echo
echo "======= Done! ======="
echo
echo "| Make sure these lines were added to /etc/default/grub:" 
if [[ "$bg_patch_applied" == "true" ]] ; then
echo -e "|   GRUB_BACKGROUND=$theme_path/dirt.png"
fi
echo -e "|   GRUB_THEME=$theme_path/theme.txt"


# Optionally run grub-mkconfig
mkconfig_cmd="$grub_prefix-mkconfig"
if [[ "$need_run_mkconfig" == "true" ]]; then
    echo "| You need to run the following command:"
    echo "| > '$mkconfig_cmd -o $grub_path/grub.cfg'" 
    echo
    if [[ "$YES" == true ]] || ask "[?] Run $mkconfig_cmd now? [Y/n] " y; then
        $mkconfig_cmd -o "$grub_path/grub.cfg"
    fi
else
    echo "| and then run:"
    echo "| > '$mkconfig_cmd -o $grub_path/grub.cfg'" 
    echo
    if [[ "$YES" != true ]] || ask "[?] Run $mkconfig_cmd now? [y/N] " n; then
        $mkconfig_cmd -o "$grub_path/grub.cfg"
    fi
fi

