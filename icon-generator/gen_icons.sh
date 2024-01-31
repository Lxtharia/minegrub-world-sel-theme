#!/bin/bash
cmd="cargo run " 
dst="../minegrub-world-selection/icons/"

### We need something other than Version that doesn't get outdated
# general classes
$cmd  os 'Operating System (01/01/1970, 0:00 AM)'	'Adventure Mode, Unknown Version'   ''   $dst
$cmd  gnu-linux  'GNU/Linux (17/09/1991, 4:58 AM)'	'GNU Mode, Not Unix, Unknown Version'   ''   $dst
# with minecraft logo
src='./world-icons/'
c=uefi		&& $cmd $c 'Uefi Settings (09/10/2006, 7:13 PM)'	'Configuration Mode, Version 2.10' $src$c.png $dst
c=windows	&& $cmd $c 'Microsoft Windows (15/07/2015, 6:19 AM)'		'Survival Mode, No Cheats, Version: 22H2' $src$c.png $dst
c=arch		&& $cmd $c 'Arch Linux (11/02/2002, 2:24 AM)'		'Creative Mode, Cheats, Version: 2.5.1' $src$c.png $dst
c=bedrock	&& $cmd $c 'Bedrock Linux (03/08/2012, 1:34 PM)'		'Adventure Mode, Version: 0.7-Poki' $src$c.png $dst
c=manjaro	&& $cmd $c 'Manjaro Linux (10/07/2011, 00:38 AM)' 		'Adventure Mode, Cheats, Version 23.0.0' $src$c.png $dst
c=linuxmint	&& $cmd $c 'Linux Mint (08/27/2006, 6:11 AM)' 		'Adventure Mode, No Cheats, Version 21.3' $src$c.png $dst

# no minecraft logo yet
src='./distro-icons/distributor-logo-'
c=debian	&& $cmd $c 'Debian (16/08/1993, 5:33 PM)'		'Survival Mode, Cheats, Version: 12' $src$c.png $dst