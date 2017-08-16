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
    uboot = pkgs.buildUBoot {
      version = "2017.09-rc1";
      src = pkgs.fetchgit {
        url = "git://git.denx.de/u-boot-sunxi.git";
        rev = "2d3c4ae350fe8c196698681ab9410733bf9017e0";
        sha256 = "caf42d36570b9b013202cf42ea55705df49c4b1b8ab755afbd8f6324614b1a09";
      };
      defconfig = "orangepi_prime_defconfig";
      patches = [
        ../../patches/orangepi-prime-u-boot.patch
      ];
      targetPlatforms = [ "aarch64-linux" ];
      filesToInstall = [ "u-boot.img" ];
    };
    uboot-spl = pkgs.buildUBoot {
      version = "2017.09-rc1";
      src = pkgs.fetchgit {
        url = "git://git.denx.de/u-boot-sunxi.git";
        rev = "a8df97d0da52b3a418de38db589357db82823214";
        sha256 = "0shka7fnfj31dhd7i8g0adjlqi2zd6m678n29v96r7iw0bbjwkyr";
      };
      defconfig = "sun50i_h5_spl32_defconfig";
      targetPlatforms = [ "aarch64-linux" ];
      filesToInstall = [ "spl/sunxi-spl.bin" ];
    };
    in {
     populateBootCommands = ''
      # Write bootloader to sd image
      dd if=${uboot-spl}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
      dd if=${uboot}/u-boot.img conv=notrunc of=$out sdX bs=1024 seek=40

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
        name = "orangepi-prime";
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

  networking.hostName = "orangepi-prime";

}
