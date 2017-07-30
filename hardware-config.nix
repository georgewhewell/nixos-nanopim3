# To build, use:
# nix-build -E 'with import <nixpkgs> { }; callPackage base.nix { }'
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-aarch64.nix -A config.system.build.sdImage
{ config, lib, pkgs, ... }:

with lib;

let
  bl1-nanopi-m3 = pkgs.callPackage ./bl1.nix { };
  uboot-nanopi-m3 = pkgs.callPackage ./uboot.nix { };
  nanopi-load = pkgs.callPackage ./nanopi-load.nix { };
  linux-4_11-nanopim3 = pkgs.callPackage ./kernel.nix { };
  linuxPackages_4_11-nanopim3 = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux-4_11-nanopim3);
  brcmfmac-nvram = pkgs.callPackage ./brcmfmac-nvram.nix { };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
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
        $(${nanopi-load}/bin/nanopi-load \
            -o u-boot-nsih.bin \
            ${uboot-nanopi-m3 }/u-boot.bin 0x43bffe00)"

      # Write bootloaders to sd image
      dd conv=notrunc if=${bl1-nanopi-m3} of=$out seek=1
      dd conv=notrunc if=u-boot-nsih.bin of=$out seek=64

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = linuxPackages_4_11-nanopim3;
  boot.initrd.kernelModules = [ "dwc2" "g_ether" "lz4" "lz4_compress" ];
  boot.initrd.availableKernelModules = [ ];
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
        '';
        uboot = null;
        kernelTarget = "Image";
        gcc = {
          arch = "armv8-a";
        };
      };
   };

  hardware.firmware = [
    brcmfmac-nvram
  ];
  
  networking.hostName = "nanopim3-nix";

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";
}
