{ config, lib, pkgs, ... }:

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
    # Write bootloader to sd image
    dd if=${pkgs.uboot-orangepi-prime}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
    dd if=${pkgs.uboot-orangepi-prime}/u-boot.img conv=notrunc of=$out bs=1024 seek=40
  '';

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;

  networking.hostName = "orangepi-prime";

}
