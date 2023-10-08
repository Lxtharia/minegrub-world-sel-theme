# Minecraft World Selection Grub Theme
Wowie, another Minecraft grub theme! But this time it's in the style of the singleplayer world selection menu, which makes a little more sense than selecting your operating system from the main menu.
There are also *icons* now! Isn't that great? And even better, they also include the descriptive text below each boot option!

![Minegrub Preview Screenshot](resources/preview_minegrub.png)

## Generate icons and description
when a `menuentry` in `grub.cfg` contains a `--class <classname>` option, grub will try to find `THEME_DIR/icons/<classname>.png` as the icon for that boot entry 

**Example:**
```bash
# grub will try to use icons/arch.png as the icon and falls back on  gnu-linux.png,  gnu.png  and  os.png
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-somefunnyuuid' {
  ...
}
```
> [icons/arch.png](minegrub-world-selection/icons/arch.png)
> 
> ![icons/arch.png](minegrub-world-selection/icons/arch.png)

### Generating icons
Because python would've been too simple, i wrote a rust "app" to generate icons like this
```
Usage: cargo run <class name> <first line> <second line> [icon filepath] [output_dir]
                |-> for default options use "-" or an empty string
```

and a haskell skript to run the rust app easily for multiple icons, pulling distro icons from ./icon-generator/distro-icons/, 
A bash script would've been way simpler but apparently, I hate simple sometimes :,)


