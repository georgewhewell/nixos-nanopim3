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
    # Write bootloader to sd image
    dd if=${pkgs.uboot-orangepi-pc2}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
    dd if=${pkgs.uboot-orangepi-pc2}/u-boot.img conv=notrunc of=$out bs=1024 seek=40
  '';

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;

  networking.hostName = "orangepi-pc2";

}
