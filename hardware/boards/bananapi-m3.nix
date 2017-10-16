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
    ./include/h3.nix
  ];

  networking.hostName = "bananapi-m3";
  system.build.dtbName = "sun8i-a83t-sinovoip-bpi-m3.dtb";
  system.build.bootloader = pkgs.uboot-bananapi-m3;

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
