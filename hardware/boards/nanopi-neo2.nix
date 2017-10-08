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
    dd if=${pkgs.uboot-nanopi-neo2}/sunxi-spl.bin of=$out bs=8k seek=1 conv=notrunc
    dd if=${pkgs.uboot-nanopi-neo2}/u-boot.itb of=$out bs=8k seek=5 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;
  networking.hostName = "nanopi-neo2";

}
