{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  nixpkgs.config.writeBootloader = let
    uboot = pkgs.buildUBoot rec {
      version = "2017.09-rc2";
      src = pkgs.fetchgit {
        url = "git://git.denx.de/u-boot.git";
        rev = "2d3c4ae350fe8c196698681ab9410733bf9017e0";
        sha256 = "caf42d36570b9b013202cf42ea55705df49c4b1b8ab755afbd8f6324614b1a09";
      };
      nativeBuildInputs = with pkgs;
        [ gcc6 bc dtc swig1 which python2 ];
      postPatch = ''
        patchShebangs tools/binman
        patchShebangs lib/libfdt
      '';
      defconfig = "orangepi_zero_defconfig";
      targetPlatforms = [ "armv7l-linux" ];
      filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
    };
  in ''
    dd if=${uboot}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.initrd.kernelModules = [ "w1-sunxi" "w1-gpio" "w1-therm" "sunxi-cir" "xradio_wlan" "xradio_wlan" ];
  boot.kernelParams = ["earlyprintk" "console=ttyS0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  boot.consoleLogLevel = 7;
  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;

  networking.hostName = "orangepi-zero";

}
