{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../common.nix
  ];

  assertions = lib.singleton {
    assertion = pkgs.stdenv.system == "armv7l-linux";
    message = "package can be only built natively on armhf-linux; " +
      "it cannot be cross compiled on ${pkgs.stdenv.system}";
  };

  sdImage =   let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
    };
    uboot = pkgs.buildUBoot rec {
      version = "2017.09-rc2";
      src = pkgs.fetchgit {
        url = "git://git.denx.de/u-boot.git";
        rev = "2d3c4ae350fe8c196698681ab9410733bf9017e0";
        sha256 = "caf42d36570b9b013202cf42ea55705df49c4b1b8ab755afbd8f6324614b1a09";
      };
      buildInputs = [ pkgs.gcc6 pkgs.swig pkgs.python ];
      defconfig = "nanopi_neo_air_defconfig";
      targetPlatforms = [ "armv7l-linux" ];
      filesToInstall = [ "u-boot.img" "spl/sunxi-spl.bin" ];
    };
    in {
     populateBootCommands = ''
      # Write bootloaders to sd image
      dd if=${uboot}/sunxi-spl.bin conv=notrunc of=$out bs=1024 seek=8
      dd if=${uboot}/u-boot.img conv=notrunc of=$out sdX bs=1024 seek=40

      # Populate ./boot with extlinux
      ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./boot
    '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.kernelParams = ["earlyprintk" "console=ttySAC0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;

  hardware.firmware = [ pkgs.ap6212-firmware ];

  nixpkgs.config = {
     allowUnfree = true;
  };

  networking.hostName = "nanopi-air";

}
