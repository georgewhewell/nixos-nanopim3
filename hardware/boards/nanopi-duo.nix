{ config, lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/wireless.nix
    ./include/otg-role.nix
  ];

  nixpkgs.config.platform = platforms.armv7l-sunxi;
  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-nanopi-duo}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';
  system.build.bootloader = pkgs.uboot-nanopi-duo;
  system.boot.loader.kernelFile = "zImage";
  boot.kernelPackages = pkgs.linuxPackages_fa;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.extraTTYs = [ "ttyS0" ];

  networking.hostName = "nanopi-duo";

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
