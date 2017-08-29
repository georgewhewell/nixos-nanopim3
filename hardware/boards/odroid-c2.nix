{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    include/common.nix
  ];

  nixpkgs.config.writeBootloader = let
    uboot = pkgs.buildUBoot rec {
      version = "2017.07";
      src = pkgs.fetchurl {
        url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
        sha256 = "1zzywk0fgngm1mfnhkp8d0v57rs51zr1y6rp4p03i6nbibfbyx2k";
      };
      defconfig = "odroid-c2_defconfig";
      targetPlatforms = [ "aarch64-linux" ];
      filesToInstall = [ "u-boot.bin" ];
    };
    in ''
    # Ref: http://git.denx.de/?p=u-boot.git;a=blob_plain;f=board/amlogic/odroid-c2/README;hb=HEAD
    export HKDIR=${pkgs.fip_create.src}

    echo "Creating FIP"
    ${pkgs.fip_create}/bin/fip_create \
      --bl30  $HKDIR/fip/gxb/bl30.bin \
      --bl301 $HKDIR/fip/gxb/bl301.bin \
      --bl31  $HKDIR/fip/gxb/bl31.bin \
      --bl33  ${uboot}/u-boot.bin \
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
  boot.kernelParams = [ "earlyprintk" "console=ttyAML0,115200n8" "console=tty0" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];

  nixpkgs.config.platform = platforms.aarch64-multiplatform;
  networking.hostName = "odroid-c2";

}
