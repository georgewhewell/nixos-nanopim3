{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    include/common.nix
  ];

  nixpkgs.config.writeBootloader = ''
    # Ref: http://git.denx.de/?p=u-boot.git;a=blob_plain;f=board/amlogic/odroid-c2/README;hb=HEAD
    export HKDIR=${pkgs.fip_create.src}

    echo "Creating FIP"
    ${pkgs.fip_create}/bin/fip_create \
      --bl30  $HKDIR/fip/gxb/bl30.bin \
      --bl301 $HKDIR/fip/gxb/bl301.bin \
      --bl31  $HKDIR/fip/gxb/bl31.bin \
      --bl33  ${uboot-odroid-c2}/u-boot.bin \
      --dump \
      fip.bin

    echo "Inserting bl2"
    cat $HKDIR/fip/gxb/bl2.package fip.bin > boot_new.bin

    echo "Wrapping u-boot"
    ${pkgs.meson-tools}/bin/amlbootsig boot_new.bin u-boot.img

    # Write bootloaders to sd image
    dd if=${pkgs.bl1-odroid-c2.default} of=$out conv=notrunc bs=1 count=442
    dd if=${pkgs.bl1-odroid-c2.default} of=$out conv=notrunc bs=512 skip=1 seek=1
    dd if=u-boot.img of=$out conv=notrunc bs=512 skip=96 seek=97
  '';

  boot.kernelPackages = pkgs.linuxPackages_amlogic;
  boot.extraTTYs = [ "ttyAML0" ];

  nixpkgs.config.platform = platforms.aarch64-multiplatform;
  networking.hostName = "odroid-c2";

}
