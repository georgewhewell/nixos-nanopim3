{ pkgs, lib, ... }:

with lib;
let
  platforms = (import ../../platforms.nix);
in
{
  imports = [
    ./allwinner-boot.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;

}
