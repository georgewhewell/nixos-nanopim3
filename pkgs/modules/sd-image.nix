{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
  ];

  sdImage = let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
    };
    in {
     populateBootCommands =
      with config.system; ''
      # Write bootloaders to sd image
      ${build.sd.installBootloader}

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${build.toplevel} -d ./boot
    '';
  };
}
