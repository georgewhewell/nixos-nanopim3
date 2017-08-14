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

  sdImage =   let
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
      defconfig = "nanopi_neo2_defconfig";
      targetPlatforms = [ "aarch64-linux" ];
      filesToInstall = [ "u-boot.img" "spl/sunxi-spl.bin" ];
    };
    in {
     populateBootCommands = ''
      # Write bootloader to sd image
      dd if=${uboot}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
      dd if=${uboot}/u-boot.img conv=notrunc of=$out bs=1024 seek=40

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_sunxi;
  boot.initrd.kernelModules = [ "dwc2" "g_ether" "lz4" "lz4_compress" ];
  boot.initrd.availableKernelModules = [ ];
  boot.kernelParams = ["earlyprintk" "console=ttyS0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;

  nixpkgs.config = {
     allowUnfree = true;
     platform = {
        name = "nanopi-neo2";
        kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
        kernelHeadersBaseConfig = "defconfig";
        kernelBaseConfig = "sun50i_defconfig";
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

  networking.hostName = "nanopi-neo2";

}
