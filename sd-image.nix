# To build, use:
# nix-build nixos -I nixos-config=nixos/modules/installer/cd-dvd/sd-image-aarch64.nix -A config.system.build.sdImage
{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

let
  extlinux-conf-builder =
    import ../../system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };
  uboot-nanopi-m3 = pkgs.callPackage ./uboot-nanopi-m3.nix { inherit pkgs; };
  nanopi-load = pkgs.callPackage ./nanopi-load.nix { inherit pkgs; };
  bl1-nanopi-m3 = pkgs.callPackage ./bl1-nanopi-m3.nix { inherit pkgs; };
  linux-4_11-nanopim3 = pkgs.callPackage ./linux-4.11-nanopim3.nix { inherit pkgs; };
  linuxPackages_4_11-nanopim3 = pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux-4_11-nanopim3);
in
{
  imports = [
    ../../profiles/minimal.nix
    ../../profiles/clone-config.nix
    ./channel.nix
    ./sd-image.nix
    ./../../../../users.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "aarch64-linux";
    message = "sd-image-aarch64.nix can be only built natively on Aarch64 / ARM64; " +
      "it cannot be cross compiled";
  };

  sdImage = {
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
  boot.initrd.availableKernelModules = [ "dm_mod" ];
  boot.kernelParams = ["earlyprintk" "console=ttySAC0,115200n8" "console=ttyS1"];
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

  services.avahi.enable = true;
  services.openssh.enable = true;

  networking.hostName = "nanopim3-nix";
  networking.networkmanager.enable = true;

  # FIXME: this probably should be in installation-device.nix
  users.extraUsers.root.initialHashedPassword = "";
}
