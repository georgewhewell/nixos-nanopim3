{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/otg-role.nix
  ];

  nixpkgs.config.writeBootloader = ''
    ${pkgs.odroid-xu3-bootloader}/bin/sd_fuse-xu3 $out
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraTTYs = [ "ttySAC2" ];
  nixpkgs.config.platform = platforms.armv7l-hf-base;
  system.build.bootloader = pkgs.odroid-xu3-bootloader;

  networking.hostName = "odroid-hc1";

}
