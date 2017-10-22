{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in rec {
  imports = [
    ./include/common.nix
    ./include/nexell-boot.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  boot.extraTTYs = [ "ttySAC0" ];
  boot.kernelPackages = pkgs.linuxPackages_nanopi-m3;

  system.build.bootloader = pkgs.symlinkJoin {
    name = "bootpackage";
    paths = with pkgs; [
      bl1-nanopi-m3
      uboot-nanopi-m3
    ];
  };

  nixpkgs.config.platform = platforms.aarch64-nanopi-m3;

  hardware.firmware = [
    pkgs.ap6212-firmware
  ];

  networking.hostName = "nanopi-m3";
  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
