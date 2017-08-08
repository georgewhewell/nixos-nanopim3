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
        defconfig = "nanopi_neo2_defconfig";
        targetPlatforms = [ "aarch64-linux" ];
        filesToInstall = [ "u-boot.bin" ];
    };
    in {
     populateBootCommands = ''
      # Add AML header to u-boot
      echo "Wrapping u-boot: \
        $(${meson-tools}/bin/amlbootsig \
            -o u-boot-sig.bin \
            ${uboot}/u-boot.bin)"

      # Write bootloaders to sd image
      dd conv=notrunc if=u-boot-nsih.bin of=$out seek=64

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = linuxPackages_odroid;
  boot.initrd.kernelModules = [ "dwc2" "g_ether" "lz4" "lz4_compress" ];
  boot.initrd.availableKernelModules = [ ];
  boot.kernelParams = ["earlyprintk" "console=ttySAC0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;

  nixpkgs.config = {
     allowUnfree = true;
     platform = {
        name = "nanopi-neo2";
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

  networking.hostName = "nanopi-neo2";

}
