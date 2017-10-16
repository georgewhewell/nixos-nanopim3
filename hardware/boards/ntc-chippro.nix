{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/h3.nix
  ];

  system.build.dtbName = "ntc-gr8-crumb.dtb";
  boot.kernelPackages = pkgs.linuxPackages_sunxi-next;
  system.build.bootloader = pkgs.uboot-ntc-chippro;
  networking.hostName = "CHIP_pro";


}
