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

## Setting icons for entries like Uefi Settings

> If you want items like Uefi Settings to have an icon, you need to add `--class uefi` manually to the menuentry line in `/boot/grub/grub.cfg`:
>
>  `menuentry "Uefi Settings" --class uefi ...`
>
> In this case you can put it in `/etc/grub.d/30_uefi-firmware` so it doesn't get overwritten when you regenerate your grub.cfg :>

## Generating/Contributing icons

Read more [here](icon-generator/README.md)

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

