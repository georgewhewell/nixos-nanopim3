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
      dd if=${pkgs.uboot-odroid-xu4}/bl1.bin.hardkernel of=$out seek=1 conv=notrunc
      dd if=${pkgs.uboot-odroid-xu4}/bl2.bin.hardkernel.720k_uboot of=$out seek=31 conv=notrunc
      dd if=${pkgs.uboot-odroid-xu4}/u-boot-dtb.bin of=$out bs=512 seek=63 conv=notrunc
      dd if=${pkgs.uboot-odroid-xu4}/tzsw.bin.hardkernel of=$out seek=1503 conv=notrunc
      dd if=/dev/zero of=$out seek=2015 bs=512 count=32 conv=notrunc
    '';
  };

  boot.extraTTYs = [ "ttySAC2" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.build.bootloader = pkgs.uboot-odroid-xu4;

  networking.hostName = "odroid-hc1";

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
