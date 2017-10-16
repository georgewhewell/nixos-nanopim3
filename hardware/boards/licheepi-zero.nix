{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/h3.nix
  ];

  system.build.dtbName = "sun8i-v3s-licheepi-zero.dtb";
  system.build.bootloader = pkgs.uboot-licheepi-zero;

  networking.hostName = "licheepi-zero";

}
