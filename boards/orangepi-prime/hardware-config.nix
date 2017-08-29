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
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "apritzel";
        repo = "u-boot";
        rev = "2d7cb5b426e7e0cdf684d7f8029ad132d7a8d383";
        sha256 = "18dvbmapijq59gaz418pz939r3vwaz6a29m5jlxfacywiggjgyrw";
      };
      patches = [
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-missing-gpio-compatibles.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-nanopineoplus2.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-pinebook-defconfig.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/disable-usb-keyboards.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/enable-DT-overlays-support.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/fix-sopine-defconfig.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/pll1-clock-fix-h5.patch"
        "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/sunxi-boot-splash.patch"
      ];
      nativeBuildInputs = with pkgs;
        [ gcc6 bc dtc swig1 which python2 ];
      preBuild = "cp ${pkgs.bl31-a64} bl31.bin";
      postPatch = "patchShebangs lib/libfdt/pylibfdt";
      defconfig = "orangepi_prime_defconfig";
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

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.kernelParams = ["console=ttyS0,115200n8" "console=ttymxc0,115200n8" "console=ttyAMA0,115200n8" "console=ttyO0,115200n8" "console=ttySAC2,115200n8" "console=tty0"];

  networking.hostName = "orangepi-prime";

}
