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
      version = "2017.09-rc2";
      src = pkgs.fetchgit {
        url = "git://git.denx.de/u-boot.git";
        rev = "2d3c4ae350fe8c196698681ab9410733bf9017e0";
        sha256 = "caf42d36570b9b013202cf42ea55705df49c4b1b8ab755afbd8f6324614b1a09";
      };
      nativeBuildInputs = with pkgs;
        [ gcc6 bc dtc swig1 which python2 ];
      preBuild = "cp ${pkgs.bl31-a64} bl31.bin";
      postPatch = "patchShebangs lib/libfdt/pylibfdt";
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

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];

  networking.hostName = "nanopi-neo2";

}
