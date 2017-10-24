{ lib, pkgs, ... }:

{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/h3.nix
  ];

  networking.hostName = "bananapi-m3";

  system.build.dtbName = "sun8i-a83t-sinovoip-bpi-m3.dtb";
  system.build.bootloader = pkgs.uboot-bananapi-m3;

  boot.kernelPackages = pkgs.linuxPackages_sunxi_a83t;

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
