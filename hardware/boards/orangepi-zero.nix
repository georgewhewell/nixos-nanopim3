{ config, lib, pkgs, ... }:

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
    dd if=${pkgs.uboot-orangepi-zero}/sunxi-spl.bin of=$out bs=8k seek=1 conv=notrunc
    dd if=${pkgs.uboot-orangepi-zero}/u-boot.itb of=$out bs=8k seek=5 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.extraTTYs = [ "ttyS0" ];

  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;

  networking.hostName = "orangepi-zero";

}
