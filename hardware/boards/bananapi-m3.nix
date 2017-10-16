{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/otg-role.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-orangepi-zero}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';

  system.boot.loader.kernelFile = "zImage";
  boot.kernelPackages = pkgs.linuxPackages_sunxi-next;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.extraTTYs = [ "ttyS0" ];
  system.build.bootloader = pkgs.uboot-bananapi-m3;

  networking.hostName = "bananapi-m3";

  system.build.usb = {
    dtbName = "sun8i-a83t-sinovoip-bpi-m3.dtb";
  };
}
