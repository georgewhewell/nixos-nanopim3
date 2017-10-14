{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/otg-role.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_sunxi-next;
  boot.extraTTYs = [ "ttyS0" ];
  boot.initrd.kernelModules = [ ];

  system.build.bootloader = pkgs.uboot-ntc-chippro;
  networking.hostName = "licheepi-zero";

  system.build.usb-loader = build:
    pkgs.writeTextDir "fel-boot.sh" ''
      # Attach device via USB
      sunxi-fel -v

      # Load kernel
      sunxi-fel \
        uboot ${build.bootloader}/bin/uboot u-boot-sunxi-with-spl.bin \
        write 0x42000000 ${build.kernel}/Image \
        write 0x43000000 ${build.kernel}/dtbs/sun8i-h2-plus-nanopi-duo.dtb \
        write 0x43100000 ${build.bootcmd}/boot.cmd \
        write 0x43300000 ${build.initialRamdisk}/initrd
    '';
}
