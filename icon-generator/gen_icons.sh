#!/bin/bash

magick_cmd=magick
if ! $(which magick &> /dev/null) ; then
    if $(which magick &> /dev/null) ; then
        magick_cmd=convert
    else
        echo "Neither found command 'magick' nor 'convert'. Make sure imagemagick is installed."
    fi
fi

create_icon ()
{
    name=$1; line_top=$2; line_bot=$3; srcimg=$4; dstdir=$5;
    if [ -z "$srcimg" ]; then
      # $magick_cmd -size 96x96 xc:none empty_image.png
      srcimg="empty_image.png"
    fi

    echo ">>> Creating icon for '$name':
    Using image: '$srcimg'
    and text:    '$line_top | $line_bot'
    Saving to    '$dstdir'"
    $magick_cmd "$srcimg" \
        -gravity center \
        -crop 1:1 +repage \
        -resize 64x64 \
        -filter point \
        -resize 96x96 \
        -gravity west \
        -background none \
        -extent 801x96 \
        -font ./MinecraftRegular.otf -pointsize 30 -fill "rgb(128,128,128)" \
        -annotate +105+0  "$line_top" \
        -annotate +105+28 "$line_bot" \
        -define png:color-type=6 \
        "$dstdir/$name.png"
}

cmd="create_icon "
dst="../minegrub-world-selection/icons/"

### We need something other than Version that doesn't get outdated
# general classes
$cmd  os 'Operating System (01/01/1970, 0:00 AM)'	'Adventure Mode, Unknown Version'   ''   $dst
$cmd  gnu-linux  'GNU/Linux (17/09/1991, 4:58 AM)'	'GNU Mode, Not Unix, Unknown Version'   ''   $dst

# with minecraft logo
src='./minecraft-world-icons/'
c=uefi		&& $cmd $c 'Uefi Settings (09/10/2006, 7:13 PM)'	'Configuration Mode, Version 2.10' $src$c.png $dst
c=windows	&& $cmd $c 'Microsoft Windows (05/10/2021, 10:11 AM)'		'Survival Mode, No Cheats, Version: 24H2' $src$c.png $dst
c=windows10	&& $cmd $c 'Microsoft Windows (15/07/2015, 6:19 AM)'		'Survival Mode, No Cheats, Version: 22H2' $src$c.png $dst
c=arch		&& $cmd $c 'Arch Linux (11/02/2002, 2:24 AM)'		'Creative Mode, Cheats, Version: 2.5.1' $src$c.png $dst
c=endeavouros	&& $cmd $c 'EndeavourOS Linux (15/07/2019, 05:30 AM)'           'Creative Mode, Cheats, Version: 3.4.1' $src$c.png $dst
c=bedrock	&& $cmd $c 'Bedrock Linux (03/08/2012, 1:34 PM)'		'Adventure Mode, Version: 0.7-Poki' $src$c.png $dst
c=manjaro	&& $cmd $c 'Manjaro Linux (10/07/2011, 00:38 AM)' 		'Adventure Mode, Cheats, Version 23.0.0' $src$c.png $dst
c=linuxmint	&& $cmd $c 'Linux Mint (08/27/2006, 6:11 AM)' 		'Adventure Mode, No Cheats, Version 21.3' $src$c.png $dst
c=kali		&& $cmd $c 'Kali Linux (03/13/2013, 4:37 PM)' 'Adventure Mode, Cheats, Version 2023.4' $src$c.png $dst
c=fedora	&& $cmd $c 'Fedora Linux (06/11/2003, 2:19 PM)'		'Survival Mode, No Cheats, Version: 39' $src$c.png $dst
c=zorin     && $cmd $c 'Zorin OS (01/07/2009, 8:54 PM)' 'Survival Mode, Cheats, Version: 17.1' $src$c.png $dst
c=nobara    && $cmd $c 'Nobara Linux (07/10/2022, 9:11 AM)' 'Creative Mode, Cheats, Version: 40' $src$c.png $dst
c=nixos     && $cmd $c 'Nix OS (03/06/2022, 3:34 AM)' 'Spectator Mode, No Cheats, Version: 24.11' $src$c.png $dst
c=artix     && $cmd $c 'Artix Linux (08/08/2017, 5:18 AM)' 'Creative Mode, No Cheats, Version: 5.6.1' $src$c.png $dst
c=cachyos   && $cmd $c 'CachyOS (30/12/2022, 12:00 AM)'		'Creative Mode, Cheats, Version: 6.13.7' $src$c.png $dst
c=ubuntu	&& $cmd $c 'Ubuntu OS (31/05/2025, 7:45 PM)'    'Survival Mode, No Cheats, Version: 24.04 LTS' $src$c.png $dst
c=gentoo	&& $cmd $c 'Gentoo Linux (04/10/2025, 4:08 PM)'    'Creative Mode, Cheats, Version: 2025-07-06' $src$c.png $dst
c=aosc      && $cmd $c 'AOSC OS (15/11/2011, 09:51 PM)'     'Survival Mode, Cheats, Version: 12.2.1' $src$c.png $dst

# no minecraft logo yet
src='./distro-icons/distributor-logo-'
c=debian	&& $cmd $c 'Debian (16/08/1993, 5:33 PM)'		'Survival Mode, Cheats, Version: 12' $src$c.png $dst

