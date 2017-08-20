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
    in {
     populateBootCommands = ''
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

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_amlogic;
  boot.initrd.kernelModules = [ "g_ether" "lz4" "lz4_compress" ];
  boot.initrd.availableKernelModules = [ "dwc2" ];
  boot.kernelParams = ["earlyprintk" "console=ttyAML0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];

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
        kernelExtraConfig = ''
           SND n

           ZPOOL y
           Z3FOLD y
           ZSWAP y
           CRYPTO_LZ4HC m

           INFINIBAND n
           DRM_NOUVEAU n
           DRM_AMDGPU n
           DRM_RADEON n
           IWLWIFI n
        '';
        uboot = null;
        kernelTarget = "Image";
        gcc = {
          arch = "armv8-a";
        };
      };
   };

  networking.hostName = "odroid-c2";

}
