local doneList = {
    {"debian", "Debian", "11/02/02/", "6.1.0", 1927},
    {"ubuntu", "Ubuntu", "11/02/02/", "6.2.4", 1712},
    {"nixos", "NixOS", "11/02/02/", "6.5.3", 1543},
    {"gentoo", "Gentoo", "11/02/02/", "6.5.3", 1143},
    {"void", "Void Linux", "11/02/02/", "6.5.3", 1378},
    {"pop-os", "PopOS", "11/02/02/", "6.5.3", 1530},
    {"bedrock", "Bedrock Linux", "30/09/12/", "6.5.3", 2481},
    {"uefi", "Uefi Settings", "01/01/1970/", "1.0.0", "no"},
}

local distroList = {
    {"arch", "Arch Linux", "11/02/2002/", "6.5.3", 1343},
}
IconDir="./distro-icons/"
DestDir="../minegrub-world-selection/icons/"

for i = 1,#distroList do
	local c = distroList[i]
	local classname, name, date, version, packages = c[1], c[2], c[3], c[4], tostring(c[5])
	local gamemode="Creative Mode"

	local iconPath=IconDir.."/icon-"..classname..".png"
	local command="cargo run '"..classname.."' '"..name.." ("..date.." "..version..")' '"..gamemode..", Cheats, "..packages.." packages' '"..iconPath.."' '"..DestDir.."'"
	print("==> Processing icon for: "..classname)
	-- print(command)
	os.execute(command)
end

