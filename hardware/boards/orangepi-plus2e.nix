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
    dd if=${pkgs.uboot-orangepi-plus2e}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';

  boot.kernelPackages = pkgs.linuxPackages_sunxi;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.extraTTYs = [ "ttyS0" ];

  networking.hostName = "orangepi-plus2e";

}
