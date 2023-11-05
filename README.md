# Minecraft World Selection Grub Theme
Wowie, another Minecraft grub theme! But this time it's in the style of the singleplayer world selection menu, which makes a little more sense than selecting your operating system from the main menu.
There are also *icons* now! Isn't that great? And even better, they also include the descriptive text below each boot option!

![Minegrub Preview Screenshot](assets/theme-preview.png)

# Installation

- Clone this repository
  ```
  git clone https://github.com/Lxtharia/minegrub-world-sel-theme.git
  ```
- [Optional]: download the background matching your screen size from [here](https://github.com/Lxtharia/minegrub-world-sel-theme/tree/c2b188a982a9ab1c092ee275e1ad1a643427d581/background-sizes)
  - And copy it to `minegrub-world-selection/background.png`
- Copy the folder to your boot partition
  ```
  cd ./minegrub-world-sel-theme
  sudo cp -ruv ./minegrub-world-selection /boot/grub/themes/
  ```
- Change/add this line in your `/etc/default/grub`:
  ```
  GRUB_THEME=/boot/grub/themes/minegrub-world-selection/theme.txt
  ```
- Update your live grub config by running
  ```
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  ```


# Also interesting
## Icons
when a `menuentry` line in `grub.cfg` contains a `--class <classname>` option, grub will try to find `THEME_DIR/icons/<classname>.png` as the icon for that boot entry 

**Example:**
```bash
# grub will try to use /boot/grub/themes/minegrub-world-selection/icons/arch.png as the icon and falls back on  gnu-linux.png,  gnu.png  and  os.png
menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-somefunnyuuid' {
  ...
}
```

## Setting icons for entries like Uefi Settings
> If you want items like Uefi Settings to have an icon, you need to add `--class uefi`  to the menuentry line in `/boot/grub/grub.cfg`:
>
>  `menuentry "Uefi Settings" --class uefi ...`
>
> In this case you can  even put it in `/etc/grub.d/30_uefi-firmware` so it doesn't get overwritten when you regenerate your grub.cfg :>

## Generating icons
The icons should look like this:

![wtf](minegrub-world-selection/icons/arch.png)

>[icons/arch.png](minegrub-world-selection/icons/arch.png)

Because python would've been too simple, i wrote a rust app to generate icons like that
```
Usage: cargo run <class name> <first line> <second line> [world icon filepath] [output_dir]
                |-> for default options use "-" or an empty string
```
and a bash script to generate multiple of them easily.

## Creating and contributing icons!
I think it's fun to have the distro icons look like Minecraft world thumbnails!

If you want to make one, go for it! Create a world and build, take a screenshot, make it square and put it in `icon-generator/world-icons/<classname>.png` (You can also position yourself, exit the world, reset the icon, enter the world, don't move and wait for a minute, leave the world, open the worlds folder and use the icon.png for more authentic image quality)
Then just add another line to `gen_icons.sh`, generate it (into `minegrub-world-selection/icons/`) and copy the theme folder into `/boot/grub/themes/` again.

Feel free to share and contribute! If only screenshot, or even text and the generated product, all welcome! 
(only the generated <classname>.png would be a bit annoying tho if you want to adjust the text, but for colored text you can use the IconTemplate.afphoto (maybe I will export it as a psd as well sometime))

# Great
- I like writing Readme but at the same time, it takes too long and it's never perfect
- Everything feels like chaos
- I spent too much time on this
- Tell your grandparents and pets about this cool theme!
- Put it on your laptop, put it on your smartwatch put it on your schools PCs (i won't take responsibility if you get expelled)
- Install it on your mouse-with-screen, copy it to your flash drives
- Btw, have I mentioned that I use arch?
- I have a grand secret project that I may reveal soon
- Maybe it eats your food, maybe it doesn't
- Thank you internet for wisdom and funny youtube clips that kept me motivated on my journey
- **Go check out the other Minegrub: [Minegrub Theme](https://github.com/Lxtharia/minegrub-theme)**
