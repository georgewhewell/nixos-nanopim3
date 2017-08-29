{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../common.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "aarch64-linux";
    message = "sd-image-aarch64.nix can be only built natively on Aarch64 / ARM64; " +
      "it cannot be cross compiled";
  };

  sdImage =   let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
    };
    in {
     populateBootCommands = ''
      # Write bootloader to sd image
      dd if=${pkgs.uboot-nanopi-neo2}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
      dd if=${pkgs.uboot-nanopi-neo2}/u-boot.img conv=notrunc of=$out bs=1024 seek=40

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];

  networking.hostName = "nanopi-neo2";

}
