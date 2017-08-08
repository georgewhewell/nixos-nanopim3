{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../common.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "aarch64-linux";
    message = "sd-image-aarch64.nix can be only built natively on Aarch64 / ARM64; " +
      "it cannot be cross compiled";
  };

  sdImage = let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
    };
    in {
     populateBootCommands = ''
      # Ref: http://git.denx.de/?p=u-boot.git;a=blob_plain;f=board/amlogic/odroid-c2/README;hb=HEAD
      export HKDIR=${pkgs.fip_create.src}

      echo "Creating FIP"
      ${pkgs.fip_create}/bin/fip_create \
        --bl30  $HKDIR/fip/gxb/bl30.bin \
        --bl301 $HKDIR/fip/gxb/bl301.bin \
        --bl31  $HKDIR/fip/gxb/bl31.bin \
        --bl33  ${pkgs.uboot-odroid-c2}/u-boot.bin \
        --dump \
        fip.bin

      echo "Inserting bl2"
      cat $HKDIR/fip/gxb/bl2.package fip.bin > boot_new.bin

      echo "Wrapping u-boot"
      ${pkgs.meson-tools}/bin/amlbootsig boot_new.bin u-boot.img

      # Write bootloaders to sd image
      dd if=$HKDIR/sd_fuse/bl1.bin.hardkernel of=$out conv=notrunc bs=1 count=442
      dd if=$HKDIR/sd_fuse/bl1.bin.hardkernel of=$out conv=notrunc bs=512 skip=1 seek=1
      dd if=u-boot.img of=$out conv=notrunc bs=512 skip=96 seek=97

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_amlogic;
  boot.initrd.kernelModules = [ "g_ether" "lz4" "lz4_compress" ];
  boot.initrd.availableKernelModules = [ "dwc2" ];
  boot.kernelParams = ["earlyprintk" "console=ttyAML0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;

  nixpkgs.config = {
     allowUnfree = true;
     platform = {
        name = "odroid-c2";
        kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
        kernelHeadersBaseConfig = "defconfig";
        kernelBaseConfig = "defconfig";
        kernelArch = "arm64";
        kernelDTB = true;
        kernelAutoModules = true;
        kernelPreferBuiltin = true;
        /*kernelExtraConfig = ''
           SND n
           BCMDHD n
           ZPOOL y
           Z3FOLD y
           ZSWAP y
           CRYPTO_LZ4HC m
        '';*/
        uboot = null;
        kernelTarget = "Image";
        gcc = {
          arch = "armv8-a";
        };
      };
   };

  networking.hostName = "odroid-c2";

}
