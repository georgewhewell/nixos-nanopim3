{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/otg-role.nix
  ];

  system.build.sd = {
    installBootloader = ''
      ${pkgs.ubootOdroidXU3}/bin/sd_fuse-xu3 $out
    '';
  };

  boot.extraTTYs = [ "ttySAC2" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.platform = platforms.armv7l-hf-base;
  system.build.bootloader = pkgs.odroid-xu3-bootloader;

  networking.hostName = "odroid-hc1";

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
