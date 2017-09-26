{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-rock64}/idbloader.bin of=$out seek=64 conv=notrunc
    dd if=${pkgs.rkbin}/img/uboot.img of=$out seek=16384 conv=notrunc
    dd if=${pkgs.rkbin}/img/trust.bin of=$out seek=24576 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_rock64;
  boot.extraTTYs = [ "ttyS0" "ttyS1" "ttyS2" "ttyFIQ0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;

  networking.hostName = "pine64-rock64";

}
