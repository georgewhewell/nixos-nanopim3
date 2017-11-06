{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in rec {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/rootfs.nix
  ];

  boot.extraTTYs = [ "ttyS0" ];
  networking.hostName = "x3399";

  hardware.firmware = [ pkgs.ap6212-firmware ];
  boot.kernelPackages = pkgs.linuxPackages_x3399;

  nixpkgs.config.platform = platforms.aarch64-x3399;

  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
