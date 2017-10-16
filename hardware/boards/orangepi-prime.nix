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

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-sunxi;
  system.build.bootloader = pkgs.uboot-orangepi-prime;

  hardware.firmware = with pkgs; [
    rtl8723bs-firmware
  ];

  networking.hostName = "orangepi-prime";

}
