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

  boot.kernelPackages = pkgs.linuxPackages_fa;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.extraTTYs = [ "ttyS0" ];

  networking.hostName = "nanopi-duo";

}
