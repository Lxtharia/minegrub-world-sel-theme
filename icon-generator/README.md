# Icon Generator

The icons should look like this:

![example-icon](../minegrub-world-selection/icons/arch.png)

>[icons/arch.png](../minegrub-world-selection/icons/arch.png)

`./gen_icons.sh` contains the generation function and also the commands with description text for each distro.

## Creating and contributing icons!

I think it's fun to have the distro icons look like Minecraft world thumbnails!

- If you want to make one, go for it! 
    - Create a world and build
    - take a screenshot, make it square
    - and put it in `icon-generator/minecraft-world-icons/<classname>.png` 
    - > For the most accurate image quality, you can pull out the image directly from minecraft: 
      > Position yourself in the world, exit the world, reset the icon, enter the world, don't move and wait for a minute, leave the world, open the worlds folder and use that icon.png

- Then just add another line to `gen_icons.sh` and generate it (into `minegrub-world-selection/icons/`) 
- Of course you have to copy the theme folder into `/boot/grub/themes/` again.


Feel free to share and contribute! Be it a screenshot or text only, or just the generated product, all welcome! 

You can also go nuts and make the world description text colorful if you want. You are free after all!!!!

## 🐈

