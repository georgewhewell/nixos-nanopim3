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
    dd if=${pkgs.uboot-pine64}/sunxi-spl.bin of=$out bs=8k seek=1 conv=notrunc
    dd if=${pkgs.uboot-pine64}/u-boot.itb of=$out bs=8k seek=5 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-sunxi;
  system.build.bootloader = pkgs.uboot-pine64;

  networking.hostName = "pine64-pine64";

}
