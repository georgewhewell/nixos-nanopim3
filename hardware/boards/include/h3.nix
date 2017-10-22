{ pkgs, lib, ... }:

with lib;
let
  platforms = (import ../../platforms.nix);
in
{
  imports = [
    ./allwinner-boot.nix
  ];

  /*nixpkgs.config.platform = platforms.armv7l-sunxi;*/

  boot.initrd.kernelModules = [ "w1-gpio" "w1-therm" "sunxi-cir" ];
  boot.extraTTYs = [ "ttyS0" ];
  boot.kernelPackages = mkDefault pkgs.linuxPackages_sunxi-next;

}
