**The Minecraft Grub Theme Trio:**

| [Minecraft Main Menu](https://github.com/Lxtharia/minegrub-theme) | *> Minecraft World Selection Menu <* | [Using both themes together](https://github.com/Lxtharia/double-minegrub-menu) |
| --- | --- | --- |

**Also check out these other projects:**
| [Minecraft SDDM Theme](https://github.com/Davi-S/sddm-theme-minesddm) by Davi-S | [Minecraft Plymouth Theme](https://github.com/nikp123/minecraft-plymouth-theme) by nikp123 | [Minecraft World Loading KDE Splash](https://github.com/Samsu-F/minecraftworldloading-kde-splash) by Samsu-F
| --- | --- | --- |

# Minecraft World Selection Grub Theme

Wowie, another Minecraft grub theme! But this time it's in the style of the singleplayer world selection menu, which makes a little more sense than selecting your operating system from the main menu.
There are also *icons* now! Isn't that great? And even better, they also include the descriptive text below each boot option!

![Minegrub Preview Screenshot](assets/theme-preview.png)

# Installation

## Installation Script
- Clone this repository
- Run the install script:
  ```bash
  git clone https://github.com/Lxtharia/minegrub-world-sel-theme.git && cd minegrub-world-sel-theme
  sudo ./install_theme.sh
  ```
- The script asks you if you want to apply some patches. These include
    - Patch to have the background of the console (pressing 'c') a dirt background
    - Patch to add the UEFI logo to the UEFI boot entry
    - Patch to add a logo for "Advanced options for ..."-submenus
    - See [patches](#patches) section

## AUR

This package is available on the AUR! You can view the package [here][aur].

To install, simply do something like the following:

```bash
yay -S grub-theme-minegrub-world-selection-git
```

Or, clone the AUR git repo locally (containing the `PKGBUILD` and such), and run `makepkg -cris`.


## Manual (linux)

- Clone this repository
  ```
  git clone https://github.com/Lxtharia/minegrub-world-sel-theme.git
  ```
- [Optional]: Choose the background matching your screen size from `assets/background-scaled/...`
  - And copy it to `minegrub-world-selection/background.png`
- Enter the cloned repository
  ```
  cd ./minegrub-world-sel-theme
  ```
- Copy the folder to your boot partition
  > **NOTE**: 
  > On some distros (like fedora) the path is `/boot/grub2/...` instead of `/boot/grub/...` so you might need to adjust the commands for that
  ```
  sudo cp -ruv ./minegrub-world-selection /boot/grub/themes/
  ```
- Change/add these line in your `/etc/default/grub`:
  ```
  GRUB_TERMINAL_OUTPUT=gfxterm
  GRUB_THEME=/boot/grub/themes/minegrub-world-selection/theme.txt
  ```
- Update your live grub config
  - Run this command:
     ```
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```
  - Or this on Fedora:
    ```
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

## NixOS flake

<details>
<summary>Minimal example</summary>

### flake.nix
```nix
{
  inputs.minegrub-world-sel-theme = {
    url = "github:Lxtharia/minegrub-world-sel-theme";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        inputs.minegrub-world-sel-theme.nixosModules.default
      ];
    };
  }
}
```
### configuration.nix
```nix
{ config, pkgs, ... }: {
  boot.loader.grub = {
    minegrub-world-sel = {
      enable = true;
      customIcons = with config.system; [
        {
          inherit name;
          lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
          lineBottom = "Survival Mode, No Cheats, Version: " + nixos.release;
          # Icon: you can use an icon from the remote repo, or load from a local file
          imgName = "nixos";
          # customImg = builtins.path {
          #   path = ./nixos-logo.png;
          #   name = "nixos-img";
          # };
        }
      ];
    };
  };
}
```
</details>


# Patches

After you've applied the patches you need to run your `grub-mkconfig ...` command.
You can also use the installation script to apply these.

## Setting the icon for the UEFI boot entry

If you want items like Uefi Settings to have an icon, you need to add `--class uefi` manually to the menuentry line in `/boot/grub/grub.cfg`:
So you need to put it in `/etc/grub.d/30_uefi-firmware` so it doesn't get overwritten when you regenerate your grub.cfg :>
 `menuentry "Uefi Settings" --class uefi ...`

## Setting the icon for "Advanced options for..."-submenu
Similar to the UEFI Boot entry, you need to change a line in `/etc/grub.d/10_linux`:
```bash
#                                                               Add this ---------vvvvvvvvvvvvvvv
echo "submenu '$(gettext_printf "Advanced options for %s" "${OS}" | grub_quote)'  --class submenu \$menuentry_id_option 'gnulinux-advanced-$boot_device_id' {"
```

## Setting a background for the Console background
The console background is black by default but can be set with `GRUB_BACKGROUND="path/to/bg.png"`.
But this needs another patch to work:
Change this line in `/etc/grub.d/00_header`
```bash
# ...
    elif [ "x$GRUB_BACKGROUND" != x ] && [ -f "$GRUB_BACKGROUND" ] \
#   ^^^^----- Change this to be
#   vvvvvv--- this
    fi; if [ "x$GRUB_BACKGROUND" != x ] && [ -f "$GRUB_BACKGROUND" ] \
# ...
```
and set this line in `/etc/default/grub`
```bash
GRUB_BACKGROUND="/boot/grub/themes/minegrub-world-selection/dirt.png"
```
NOTE: This line should stand BEFORE `GRUB_THEME=...`.


# Icons

GRUB can add icons to each entry, based on the `--class` properties of a `menuentry`.
This theme makes use of this to have each entry have its own icon _and_ world description!
**Example:**
```bash
# grub will try to use /boot/grub/themes/minegrub-world-selection/icons/arch.png as the icon and falls back on  gnu-linux.png,  gnu.png  and  os.png
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-somefunnyuuid' {
  ...
}
```


## [Generating/Contributing icons](icon-generator/README.md)

If you notice that the icon for a distro is missing, then you're probably right!
Then you should open Minecraft, build it, take a screenshot and contribute it to this repo!
Click [here](icon-generator/README.md) to read more

# Great

- I like writing Readme but at the same time, it takes too long and it's never perfect
- Everything feels like chaos
- I spent too much time on this
- Tell your grandparents and pets about this cool theme!
- Put it on your laptop, put it on your smartwatch put it on your schools PCs (i won't take responsibility if you get expelled)
- Install it on your mouse-with-screen, copy it to your flash drives
- Btw, have I mentioned that I use arch?
- Thank you internet for wisdom and funny youtube clips that kept me motivated on my journey
- **Go check out the other Minegrub: [Minegrub Theme](https://github.com/Lxtharia/minegrub-theme)**

  [aur]:https://aur.archlinux.org/packages/grub-theme-minegrub-world-selection-git
