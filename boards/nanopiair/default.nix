# To build, use:
# nix-build -E 'with import <nixpkgs> { }; callPackage base.nix { }'
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-aarch64.nix -A config.system.build.sdImage

# nix-build '<nixpkgs/nixos>' -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz -I nixos-config=/mnt/Home/src/nixos-nanopim3/minimal.nix -A config.system.build.sdImage -o nixos-unstable.img -j 4
{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../common.nix
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

  hardware.firmware = [ pkgs.ap6212-firmware ];

  nixpkgs.config = {
     allowUnfree = true;
     platform = {
        name = "odroid-c2";
        kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
        kernelHeadersBaseConfig = "defconfig";
        kernelBaseConfig = "defconfig";
        kernelArch = "armhf";
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
          arch = "armhf";
        };
      };
   };

  networking.hostName = "nanopiair";

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";
}
