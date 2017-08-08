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
    in {
     populateBootCommands = ''
      # Add NISH header to u-boot
      echo "Wrapping u-boot: \
        $(${pkgs.nanopi-load}/bin/nanopi-load \
            -o u-boot-nsih.bin \
            ${pkgs.uboot-nanopi-m3 }/u-boot.bin 0x43bffe00)"

      # Write bootloaders to sd image
      dd conv=notrunc if=${pkgs.bl1-nanopi-m3} of=$out seek=1
      dd conv=notrunc if=u-boot-nsih.bin of=$out seek=64

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.kernelPackages = pkgs.linuxPackages_nanopi-m3;
  boot.initrd.kernelModules = [ "g_ether" ];
  boot.initrd.availableKernelModules = [ "dwc2" ];
  boot.kernelParams = ["earlyprintk" "console=ttySAC0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;

  nixpkgs.config = {
     allowUnfree = true;
     platform = {
        name = "nanopi-m3";
        kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
        kernelHeadersBaseConfig = "defconfig";
        kernelBaseConfig = "nanopim3_defconfig";
        kernelArch = "arm64";
        kernelDTB = true;
        kernelAutoModules = true;
        kernelPreferBuiltin = true;
        kernelExtraConfig = ''
           SND n
           BCMDHD n
           ZPOOL y
           Z3FOLD y
           ZSWAP y
           CRYPTO_LZ4HC m

           INFINIBAND n
           DRM_NOUVEAU n
           DRM_AMDGPU n
           IWLWIFI n
        '';
        uboot = null;
        kernelTarget = "Image";
        gcc = {
          arch = "armv8-a";
        };
      };
   };

  hardware.firmware = [
    pkgs.ap6212-firmware
  ];

  networking.hostName = "nanopim3-nix";

}
