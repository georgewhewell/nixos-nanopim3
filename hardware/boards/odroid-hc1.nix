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
		dd if=${pkgs.uboot-odroid-xu4}/bl1.bin.hardkernel of=$out seek=1 conv=notrunc
		dd if=${pkgs.uboot-odroid-xu4}/bl2.bin.hardkernel.720k_uboot of=$out seek=31 conv=notrunc
		dd if=${pkgs.uboot-odroid-xu4}/u-boot-dtb.bin of=$out bs=512 seek=63 conv=notrunc
		dd if=${pkgs.uboot-odroid-xu4}/tzsw.bin.hardkernel of=$out seek=1503 conv=notrunc
  '';

  boot.kernelPackages = pkgs.linuxPackages_xu4;
  boot.extraTTYs = [ "ttySAC2" ];
  nixpkgs.config.platform = platforms.armv7l-hf-base;

  networking.hostName = "odroid-hc1";

}
