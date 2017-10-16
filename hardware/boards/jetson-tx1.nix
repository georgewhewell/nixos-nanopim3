{  lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-jetson-tx1}/u-boot.bin of=$out bs=8k seek=1 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;
  system.build.bootloader = pkgs.uboot-jetson-tx1;

  networking.hostName = "jetson-tx1";

}
