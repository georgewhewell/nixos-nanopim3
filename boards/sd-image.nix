{ config, lib, pkgs, ... }:

{
  sdImage = let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
    };

    in {
     populateBootCommands = ''
      # Write bootloaders to sd image
      ${pkgs.config.writeBootloader}

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };
}
