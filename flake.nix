{
  description = "Flake for minegrub world selection theme";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in with nixpkgs.lib; {
      nixosModules.default = { config, ... }:
        let
          cfg = config.boot.loader.grub.minegrub-world-sel;

          minegrub-world-sel-theme = pkgs.stdenv.mkDerivation {
            name = "minegrub-world-sel-theme";
            src = "${self}";

            buildInputs = [ pkgs.jq pkgs.imagemagick ];

            installPhase = ''
              mkdir -p $out/grub/theme/

              customIconsJson='${builtins.toJSON cfg.customIcons}'

              cd icon-generator

              source ./gen_icons.sh
              echo gen_icons Script done

              echo "$customIconsJson" | jq -c '.[]' | while read -r item; do
                lineBottom=$(echo "$item" | jq -r '.lineBottom')
                lineTop=$(echo "$item" | jq -r '.lineTop')
                name=$(echo "$item" | jq -r '.name')
                imgName=$(echo "$item" | jq -r '.imgName')
                customImg=$(echo "$item" | jq -r '.customImg')

                if [ "$customImg" != null ]; then
                  echo "Using custom image for $name ($customImg)"
                  iconFile=$customImg
                else
                  # If customImg is not set use image from the repo

                  # Premade icons
                  iconFile="minecraft-world-icons/$imgName.png"

                  # If no premade icon exists, use generic logo
                  if [ ! -e "$iconFile" ]; then
                    iconFile="distro-icons/distributor-logo-$imgName.png"

                    # Generic distribution icon not found.. default to empty image
                    if [ ! -e "$iconFile" ]; then
                      iconFile="./empty_image.png"
                    fi
                  fi
                fi

                # Create the icon and copy to theme icons folder
                create_icon "$name" "$lineTop" "$lineBottom" "$iconFile" "../minegrub-world-selection/icons"

              done

              cp -r ../minegrub-world-selection/* $out/grub/theme/
            '';
          };
        in {
          options = {
            boot.loader.grub.minegrub-world-sel = {
              enable = mkOption {
                type = types.bool;
                default = false;
                example = true;
                description = ''
                  Enable Minegrub world selection theme
                '';
              };
              customIcons = mkOption {
                type = types.listOf (types.attrsOf types.str);
                example = [{
                  name = "nixos";
                  lineTop = "NixOS (23/11/2023, 23:03)";
                  lineBottom = "Survival Mode, No Cheats, Version: 23.11";
                  imgName = "nixos";
                  customImg = builtins.path {
                    path = ./nixos.png;
                    name = "nixos-img";
                  };
                }];
                description = ''
                  - name: Name of the operating system.
                  - lineTop: Top line text
                  - lineBottom: Bottom line text
                  For icon file choose only one source:
                  - imgName: Name of the icon to load from the minegrub repository. (from icon-generator folder)
                  - customImg: Path to a custom image file stored locally.
                '';
              };
            };
          };

          config = mkIf cfg.enable (mkMerge [{
            environment.systemPackages = [ minegrub-world-sel-theme ];
            boot.loader.grub = {
              theme = "${minegrub-world-sel-theme}/grub/theme";
            };
          }]);
        };
    };
}
