{ config, lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in {
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
      postPatch = "patchShebangs lib/libfdt/pylibfdt";
      defconfig = "nanopi_neo_air_defconfig";
      targetPlatforms = [ "armv7l-linux" ];
      filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
    };
    in ''
      # Write bootloaders to sd image
      dd if=${uboot}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
    '';

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.kernelParams = ["earlyprintk" "console=ttyS0,115200n8" "console=tty0" "brcmfmac.debug=30" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];

  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;
  hardware.firmware = [ pkgs.ap6212-firmware ];

  networking.hostName = "nanopi-air";

}
